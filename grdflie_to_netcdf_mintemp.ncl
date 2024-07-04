
mintemp_file=systemfunc("ls IMD_MinT_1x1_*.grd")

file_strs1 = str_split(mintemp_file(0),"_")
file_strs2 = str_split(file_strs1(3),".")

Year=tointeger(file_strs2(0))

fName = mintemp_file(0)

nlat  = 31                               ; YDEF
mlon  = 31	                         ; XDEF

isleap = isleapyear(Year)
print(isleap)
if(isleap.eq."True")then
ntim  = 366
else                              ; time steps
ntim = 365
end if
 
nmos  = 12

date  = new (ntim, integer,"No_FillValue") ; generate a "date" variable

n= -1
n1=0

do nmo=1,nmos
   YRM= Year*10000 + nmo*100
   ndm= days_in_month(Year, nmo)  
 
   do ndy=1,ndm  
       n = n+1
       n1 = n1+1
       date(n) = YRM + ndy                ; YYYYMMDD
    end do
 end do

  
yyyy  = date/10000 
mmdd  = date-yyyy*10000                ; mmdd = yyyymmdd%10000
mm    = mmdd/100
dd    = mmdd-mm*100                        ; dd   = mmdd%100

hh    = dd                                 ; create arrays [*] of required size
mn    = dd
sc    = dd

hh    = 0                                  ; array syntax
mn    = 0
sc    = 0
                                             
units  = "hours since 1900-01-01 00:00:00" ; "seconds/hours/days since ...."
time   = cd_inv_calendar(yyyy,mm,dd,hh,mn,sc,units, 0)
time!0 = "time"
;=================================================================

lon = ispan(0,mlon-1,1)*1.0 + 67.5
lon!0 = "lon"
lon@long_name = "longitude"
lon@units     = "degrees_east"


lat = ispan(0,nlat-1,1)*1.0 + 7.5
lat!0 = "lat"
lat@long_name = "latitude"
lat@units     = "degrees_north"

                                          ; create an array to contain data
UNDEF = 99.9                           ; UNDEF

x     = new ( (/ntim,nlat,mlon/), float, UNDEF)
x!0   = "time"
x!1   = "lat"
x!2   = "lon"
x&time=  time
x&lat =  lat
x&lon =  lon

x@long_name = "Tmin"         ; VARS
x@units     = "degree"                 
                                    
x@fillvalue=99.9
do nt=0,ntim-1                         ; the ::-1 changes the latitude order
   x(nt,:,:) = fbindirread(fName, nt,(/nlat,mlon/), "float")
end do

print ("min(x)="+min(x))
print ("max(x)="+max(x))
;=========================================================

nline= inttochar(10)
        
filo = "Imd_MinT_"+Year+".nc"
system ("/bin/rm -f "+filo)  ; remove any pre-existing file

ncdf = addfile (filo, "c")
setfileoption(ncdf,"DefineMode",True)               ; a033 [most efficient]
      
globeAtt         = 1      ; global [file] attributes
globeAtt@title   = "Tmin"
globeAtt@source  = "IMD 1x1 data"

globeAtt@story   = "Imd Gridded data"
globeAtt@creation_date= systemfunc ("date" ) 

fileattdef( ncdf, globeAtt )
                                 
dimNames = (/"time", "lat", "lon" /)  	
dimSizes = (/  -1  ,  nlat,  mlon /) 
dimUnlim = (/ True , False, False /)   
filedimdef(ncdf, dimNames  , dimSizes,  dimUnlim )

filevardef   (ncdf, "time"  , typeof(time) , "time" )
filevarattdef(ncdf, "time", time)
     
filevardef   (ncdf, "lat", "float", "lat")
filevarattdef(ncdf, "lat", lat)
     
filevardef   (ncdf, "lon", "float", "lon")
filevarattdef(ncdf, "lon", lon)
     
      
filevardef(ncdf, "Tmin"  , typeof(x) , (/"time", "lat" , "lon"/) )
filevarattdef(ncdf, "Tmin", x)

ncdf->time   = (/ time /)   
ncdf->lat    = (/ lat /)
ncdf->lon    = (/ lon /)
ncdf->Tmin   = (/ x /) 
