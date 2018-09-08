const path = require('path');
const fs = require('fs');
const solc = require('solc');

// const pathTilesChain = path.resolve(__dirname, './', 'TilesChain.sol');
const pathQuest = path.resolve(__dirname + "/contracts", 'legendary.sol');
const pathOwnable = path.resolve(__dirname + "/contracts", 'ownable.sol');
const pathSafemath = path.resolve(__dirname + "/contracts", 'safemath.sol');

// const solTilesChain = fs.readFileSync(pathTilesChain, 'utf8');
const solQuest = fs.readFileSync(pathQuest, 'utf8');
const solOwnable = fs.readFileSync(pathOwnable, 'utf8');
const solSafemath = fs.readFileSync(pathSafemath, 'utf8');

const input = {
  sources: {
    // 'TilesChain.sol': solTilesChain,
    'quest.sol': solQuest,
    'ownable.sol': solOwnable,
    'safemath.sol': solSafemath
  }
};

const compiledContract = solc.compile(input, 1);
// console.log(compiledContract);

let abi = compiledContract.contracts['quest.sol:LegendQuest'].interface;
let bytecode = '0x'+compiledContract.contracts['quest.sol:LegendQuest'].bytecode;

fs.writeFileSync('legendary.abi', abi);
fs.writeFileSync('legendary.bin', bytecode);
// console.log(abi);
// console.log(bytecode);
