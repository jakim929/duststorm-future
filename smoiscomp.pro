device, decompose=0
device, retain=2

free_lun, 20
free_lun, 21
openr, 20, '/home2/sunwoo/final_output/point_output_southern_saudi/point_smois_current.csv'
openr, 21, '/home2/sunwoo/final_output/point_output_southern_saudi/point_smois_future.csv'

smois1 = fltarr(365)
smois2 = fltarr(365)
DAY = FINDGEN(365)
readf,20,smois1
readf,21,smois2
;print,stddev(smois1)
;print,stddev(smois2)
print, mean(smois1)
print,mean(smois2)

!p.multi = [0, 1, 2]
window, xsize =1200, ysize=3000

plot, DAY, smois1, background=fsc_color('white'), title='Soil Moisture 2001', color=fsc_color('black'), thick=3, xstyle=3, ystyle=19, $
      yrange=[0, 0.5], charsize=3.4, xrange = [0,366], xtickinterval=31, xminor=1, $
      ytitle='Soil Moisture!c(m3m-3)', linestyle=2, xmargin=11, xthick=2, ytickinterval=1*10^(-7), ythick=2, charthick=2
oplot, DAY, smois1, color=fsc_color('black'), thick=2 

plot, DAY, smois2, background=fsc_color('white'), title='Soil Moisture 2081', color=fsc_color('black'), thick=3,xstyle=3, ystyle=19, $
      yrange=[0, 0.5], charsize=3.4, xrange = [0,366], xtitle='Day of the Year',xtickinterval=31, xminor=1, $
      ytitle='Soil Moisture!c(m3m-3)', linestyle=2, xmargin=11, xthick=2, ytickinterval=1*10^(-7), ythick=2, charthick=2
oplot, DAY, smois2, color=fsc_color('black'), thick=2 


snapshot=tvread(true=1)
;Write_png, '/home2/sunwoo/point_comparison/smoiscomp_lks.png', snapshot ; Save the pop-up window image


close,20
close,21
end