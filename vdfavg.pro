pro vdfavg
device, decompose=0
device, retain=2
;vdfavg = float(117,111)

dir = '/home2/sunwoo/final_output/coutput1/vdf_output_current.tif'

data = read_tiff(dir)
vdfavg = data(*,*,0) +data(*,*,1) +data(*,*,2) +data(*,*,3) +data(*,*,4) +data(*,*,5) +data(*,*,6)$
			 +data(*,*,7) +data(*,*,8) +data(*,*,9) +data(*,*,10) +data(*,*,11) 

vdfavg = vdfavg / 12
print, vdfavg

write_tiff, '/home2/sunwoo/final_output/vdf_average_2001.tif', vdfavg, /float
end