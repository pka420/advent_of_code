import { readFileSync } from "node:fs";
const input = readFileSync("./test.txt", "utf8").trimEnd();
const list = input.split("\n").map((line) => line.split(""));

console.log("length of list: ", list.length)

function findAllHikes(curr, path, seen, list, allPaths) {
  const [x, y] = curr;
  const row = list.length;
  const col = list[0].length;

  if ( x < 0 || x > row - 1 || y < 0 || y > col - 2 || list[x][y] === "#" || seen[x][y] ) {
    return;
  }

  path.push(curr);
  seen[x][y] = true;

  if (x === row - 1 && y === col - 2 ) {
    allPaths.push([...path]);
  } else {
    const dir = list[x][y];
    if (dir === "v") {
      findAllHikes([x + 1, y], path, seen, list, allPaths); // Go down
    } else if (dir === ">") {
      findAllHikes([x, y + 1], path, seen, list, allPaths); // Go right
    } else if (dir === "<") {
      findAllHikes([x, y - 1], path, seen, list, allPaths); // Go left
    } else if (dir === "^") {
      findAllHikes([x - 1, y], path, seen, list, allPaths); // Go up
    }
    else {
      const directions = [[1, 0], [0, 1], [0, -1], [-1, 0]];
      for (const [dx, dy] of directions) {
          findAllHikes([x + dx, y + dy], path, seen, list, allPaths);
      }
    }
  }

  path.pop();
  seen[x][y] = false;
}

const start = [0, 1];
console.log(`Start: ${start[0]} ${start[1]}`);
const seen = [];
const path = [];
const allPaths = [];

for (let i = 0; i < list.length; ++i) {
  seen.push(new Array(list[0].length).fill(false));
}

findAllHikes(start, path, seen, list, allPaths);

console.log("all paths: ", allPaths.length);

const lengths = new Set();
allPaths.forEach((path) => {
    lengths.add(path.length - 1);
});
const maxLength = Array.from(lengths).sort((a,b) => b-a)[0];
console.log("max length: ", maxLength);
