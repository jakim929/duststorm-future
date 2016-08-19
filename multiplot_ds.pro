pro multiplot_ds

PRECIP = [0.5,0.7,1.2,1.8,2.5,1.6,1.9,1.5,1.2,1.0,0.8,0.6]
TEMP = [30, 34, 38, 47, 57, 67, 73, 71, 63, 52, 39, 33]
DAY = FINDGEN(12) * 30 + 15

vdf = float(365)
ust = float(365)

fname1 = '/home2/sunwoo/output/point_vdf_current.csv'
fname2 = '/home2/sunwoo/output/point_ust_current.csv'


;get_lun, u
;openr, u, fname2
;readf, u, ust
;free_lun, u

openr, 21, fname1
readf, 21, vdf
close,/all

plot, vdf

end