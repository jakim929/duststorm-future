;Data dimension setting
dx   = 117
dy   = 111

mask = read_tiff('/home2/sunwoo/mask.tif')
data = read_tiff('/home2/sunwoo/smois_output_current.tif') ; read the MP LAI outputs 
;data = read_tiff('/home2/sunwoo/smois_output_future.tif') ; read the MP LAI outputs 
;data = reverse(data,2)
index = where(mask eq 0)
nmon = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC']



for i=10, 10 do begin
corr = fltarr(dx,dy)
corr= float(data(*,*,i))
corr(index) = -999.

input = fltarr(dx,dy) ; Making a new arrary for drawing

Tmax = 0.3 ; Setting Coef. maximum value
Tmin = 0 ; Setting Coef. minimum value

index = where(corr ge Tmin and corr le Tmax, count)
if count ne 0 then input(index) = (1-(corr(index) - Tmin)/(Tmax - Tmin))*252.
index = where(corr lt Tmin, count)
if count ne 0 then input(index) = 252.
index = where(corr gt Tmax, count)
if count ne 0 then input(index) = 1.
index = where(corr lt -100., count)
if count ne 0 then input(index) = 255

Device, Decomposed=0, Get_Decomposed=currentColorModel
Window, /free, XSize=1000, YSize=950 ; Setting the image size
Erase, color=fsc_color('white') ; Setting the backgrounc color

   map = MAP_PROJ_INIT(117,sphere_radius=1., center_longitude = 0.) ; Setting the map projection

   smap=[30.95,8.85,66.05,42.15] ; Setting the range of LAT and LONG
   map.uv_box=[0.,0.,0.,0.]
   map.uv_box=smap*3.14/180. ; Converting coordinate system

DEVICE, SET_FONT='Helvetica', /TT_FONT ; Setting the font type

   Image_position1=[0.04, 0.05, 0.84, 0.85] ; setting the image position
   loc=[0.89, 0.05, 0.92,0.84] ; setting the legend position
   Plot, map.uv_box[[0, 2]], map.uv_box[[1, 3]], Position=Image_position1, $ ; creating the space for the image
     /NoData, XStyle=5, YStyle=5, xthick=2, /NoErase

LoadCT, 0, /Silent ; Loading the colobr table for the background
   TVLCT, FSC_Color('ivory', /Triple), 0 ; Setting the background in the assigned space
   LoadCT, 33, NColors=253, Bottom=0, /Silent ; Loading the color table for color map
   TVIMAGE, input, POSITION=Image_position1, /NOINTERP;, /KEEP_ASPECT ; Project the image into the space
   colorbar, NCOLORS=253, POSITION=loc, divisions=5, /reverse, /vertical, color='black', $; Drawing the color bar
             charsize=1.5, minrange=Tmin, maxrange=Tmax, /right, charthick=2, format='(F3.1)'
   Map_Grid, box_axes=3, /Label, charsize=2, Color=FSC_Color('black'), Map_Structure=map, londel=5, latdel=5, glinethick=1.5, charthick = 2 ; Drawing the edges with Lat and Long
   Map_Continents, /countries, /USA, /coasts, /HIRES, color=fsc_color('black'), mlinethick=1.5, Map_Structure=map ; Drawing the coast and country line
   ;XYOutS, 0.5, 0.915, 'Correlation btw MODIS LAI and MP LAI', font=1, charsize=4, Color=FSC_Color('black'), $ ; Putting the Title
   ;XYOutS, 0.5, 0.915, 'MP meanLAI from 2001 to 2010', font=1, charsize=4, Color=FSC_Color('black'), $ ; Putting the Title
   XYOutS, 0.5, 0.915, 'Soil moisture (m3/m3) for '+nmon(i)+', 2001', font=1, charsize=4, Color=FSC_Color('black'), $ ; Putting the Title
         /Normal, Alignment=0.5
      snapshot=tvrd(true=1)
   ;Write_png, '/home2/sunwoo/smois_'+nmon(i)+'_01.png', snapshot ; Save the pop-up window image
endfor
end
