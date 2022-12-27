pack:
	zip -9 -r -j game-of-life.love game-of-life/*

web:
	npx love.js -c game-of-life.love life
	zip -9 -r -j life.zip life/*