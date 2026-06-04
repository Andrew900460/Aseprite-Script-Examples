-- Export all tags into a single PNG
-- Each tag occupies one row

local src = app.activeSprite
if not src then
	print("No active sprite")
	return
end

local path, title = src.filename:match("^(.+[/\\])(.-).([^.]*)$")
if not path then
	path = ""
	title = src.filename
end

-- Find longest animation
local maxFrames = 0
for _, tag in ipairs(src.tags) do
	local count = tag.toFrame.frameNumber - tag.fromFrame.frameNumber + 1
	maxFrames = math.max(maxFrames, count)
end

local imageWidth = src.width
local imageHeigt = src.height
local numRows = #src.tags
local out = Sprite(imageWidth * maxFrames, imageHeigt * numRows, src.colorMode)

function GenerateSpriteSheet()
	for row, tag in ipairs(src.tags) do
		local startFrame = tag.fromFrame.frameNumber
		local endFrame = tag.toFrame.frameNumber
		local col = 0
		
		for frameIndex = startFrame, endFrame do
			local cel = src.cels[frameIndex]
			
			if cel then
				local img = cel.image
				local dstX = col * imageWidth
				local dstY = (row - 1) * imageHeigt
				
				out.cels[1].image:drawImage(img, Point(dstX, dstY))
			end
			col = col + 1
		end
	end
end

app.transaction(GenerateSpriteSheet)

local filename = path .. title .. "-full.png"

out:saveCopyAs(filename)

print("Exported: " .. filename)

out:close()
