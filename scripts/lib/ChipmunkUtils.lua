--通过PE导出的physicsData生成一个body
function createBody(physicsData , world)
    local body = nil
    for i , shape in ipairs(physicsData.shapes) do
        local polygons = shape.polygons
        for n , v in ipairs(polygons) do
            local vertexes = CCPointArray:create(#v / 2)
            for j = 1, #v, 2 do
                vertexes:add(cc.p(v[j], v[j+1]))
            end
            if not body then
                body = world:createPolygonBody(shape.mass, vertexes) 
            else
                body:addPolygonShape(vertexes)
            end
        end
        body:setFriction(shape.friction)
        body:setElasticity(shape.elasticity)
        body:setCollisionType(shape.collision_type)
    end
    return body
end