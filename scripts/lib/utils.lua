--将table2插入table1后面并返回table1
function concatTable(table1 , table2)
	for i = 1, #table2 do
		table.insert(table1 , table2[i])
	end
	return table1
end

--剔除nil元素,返回一个新的table
function trimNilValue(t)
	local t2 = {}
	for i = 1 , #t do
		if t[i] ~= nil then
			table.insert(t2 , t[i])
		end
	end
	return t2
end

--角度转换为弧度
function ang2rad(angle)
	return angle / 180 * math.pi
end

--弧度转换为角度
function rad2ang(rad)
	return rad * 180
end