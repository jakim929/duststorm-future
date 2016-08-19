pro setarray
fname = '/home2/sunwoo/csvoutput/point_tust_current.csv'
read_data1, 1, ptustc, fname
fname1 = '/home2/sunwoo/csvoutput/point_tust_future.csv'
read_data1, 2, ptustf, fname1
compare1, ptustc,ptustf,ptustcomp
plot, ptustcomp
end