--将table2插入table1后面并返回table1
function concatTable(table1 , table2)
	for i = 1, #table2 do
		table.insert(table1 , table2[i])
	end
	return table1
end

--角度转换为弧度
function ang2rad(angle)
	return angle / 180 * math.pi
end

--弧度转换为角度
function rad2ang(rad)
	return rad * 180
end