-- This file is for use with quick-cocos2d-x framework
-- https://github.com/dualface/quick-cocos2d-x
-- bugFixed by ChildhoodAndy on 2014/02/01
-- This file is automatically generated with PhysicsEdtior (http://physicseditor.de). Do not edit
--
-- Usage example:
--			local scaleFactor = 1.0
--			local physicsData = require("shapedefs").physicsData(scaleFactor)
--			local shape = display.newSprite("objectname.png")
--          physics.bindBody(shape, physicsData:get("objectname"))
--

-- copy needed functions to local scope
local pairs = pairs
local ipairs = ipairs

local M = {}

function M.physicsData(scale)
    local physics = {data = {}}

    

    physics.data["grapes"] = {
        anchorpoint = { 0.50000,0.50000 },
        shapes = {
            
            {
                mass = 2,
                elasticity = 0,
                friction = 0,
                surface_velocity = { 0.00000,0.00000 },
                layers = 0,
                group = 0,
                collision_type = 1,
                isSensor = false,
                shape_type = "POLYGON",
                
                polygons = {
                    
                    {44.50000, 31.00000, 24.50000, -37.00000, 12.00000, -58.50000, 0.00000, -60.50000, -30.50000, -30.00000, -26.00000, -8.00000, -1.00000, 41.00000, 14.00000, 58.50000, },
                    
                    {-23.00000, 39.00000, -1.00000, 41.00000, -26.00000, -8.00000, -37.00000, 15.00000, },
                    
                }
                
            },
            
        },
    }

    

    physics.data["pineapple"] = {
        anchorpoint = { 0.50000,0.50000 },
        shapes = {
            
            {
                mass = 2,
                elasticity = 0,
                friction = 0,
                surface_velocity = { 0.00000,0.00000 },
                layers = 0,
                group = 0,
                collision_type = 1,
                isSensor = false,
                shape_type = "POLYGON",
                
                polygons = {
                    
                    {43.00000, 9.00000, 15.00000, 0.00000, -1.00000, 16.00000, 22.00000, 59.00000, 51.00000, 59.00000, },
                    
                    {-51.00000, 0.00000, -23.00000, 19.00000, 15.00000, 0.00000, 0.00000, -55.00000, -22.00000, -64.00000, -52.00000, -52.00000, -62.00000, -28.00000, },
                    
                    {0.00000, -55.00000, 15.00000, 0.00000, 23.00000, -22.00000, },
                    
                    {15.00000, 0.00000, -23.00000, 19.00000, -1.00000, 16.00000, },
                    
                }
                
            },
            
        },
    }

    

    physics.data["strawberry"] = {
        anchorpoint = { 0.50000,0.50000 },
        shapes = {
            
            {
                mass = 2,
                elasticity = 0,
                friction = 0,
                surface_velocity = { 0.00000,0.00000 },
                layers = 0,
                group = 0,
                collision_type = 1,
                isSensor = false,
                shape_type = "POLYGON",
                
                polygons = {
                    
                    {-5.00000, -47.50000, -40.50000, -12.00000, -46.00000, 22.50000, -2.00000, 54.50000, -1.00000, 54.50000, 42.50000, 22.00000, 47.50000, -18.00000, 34.00000, -55.50000, },
                    
                }
                
            },
            
        },
    }

    

    physics.data["watermelon"] = {
        anchorpoint = { 0.50000,0.50000 },
        shapes = {
            
            {
                mass = 2,
                elasticity = 0,
                friction = 0,
                surface_velocity = { 0.00000,0.00000 },
                layers = 0,
                group = 0,
                collision_type = 1,
                isSensor = false,
                shape_type = "POLYGON",
                
                polygons = {
                    
                    {-5.00000, 56.50000, -4.00000, 56.50000, 11.50000, 45.00000, 56.50000, -36.00000, 30.00000, -50.50000, -18.00000, -53.50000, -54.50000, -33.00000, },
                    
                }
                
            },
            
        },
    }

    

    physics.data["fish_head"] = {
        anchorpoint = { 0.50000,0.50000 },
        shapes = {
            
            {
                mass = 0,
                elasticity = 0,
                friction = 0,
                surface_velocity = { 0.00000,0.00000 },
                layers = 0,
                group = 0,
                collision_type = 2,
                isSensor = false,
                shape_type = "POLYGON",
                
                polygons = {
                    
                    {14.50000, 2.00000, 12.50000, -33.00000, 3.50000, -40.00000, -6.50000, -38.00000, -12.50000, -25.00000, -12.50000, 0.00000, -0.50000, 48.00000, },
                    
                }
                
            },
            
        },
    }

    

    -- apply scale factor
    local s = scale or 1.0
    for bi, body in pairs(physics.data) do
        for fi, shape in ipairs(body.shapes) do
            if shape.polygons then
                for ci, coordinate in ipairs(shape.polygons) do
                    for i, point in ipairs(coordinate) do
                        point = s * point
                    end
                end

            else
                shape.radius = s * shape.radius
            end
        end
    end

    function physics:get(name)
        return self.data[name]
    end

    return physics
end

return M
