['pragma solidity ^0.4.19;\n', '/*\n', 'Game: CryptoPokemon\n', 'Domain: CryptoPokemon.com\n', 'Dev: CryptoPokemon Team\n', '*/\n', '\n', 'library SafeMath {\n', '\n', '/**\n', '* @dev Multiplies two numbers, throws on overflow.\n', '*/\n', 'function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', 'if (a == 0) {\n', 'return 0;\n', '}\n', 'uint256 c = a * b;\n', 'assert(c / a == b);\n', 'return c;\n', '}\n', '\n', '/**\n', '* @dev Integer division of two numbers, truncating the quotient.\n', '*/\n', 'function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '// assert(b > 0); // Solidity automatically throws when dividing by 0\n', 'uint256 c = a / b;\n', '// assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', 'return c;\n', '}\n', '\n', '/**\n', '* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '*/\n', 'function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', 'assert(b <= a);\n', 'return a - b;\n', '}\n', '\n', '/**\n', '* @dev Adds two numbers, throws on overflow.\n', '*/\n', 'function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', 'uint256 c = a + b;\n', 'assert(c >= a);\n', 'return c;\n', '}\n', '}\n', '\n', 'contract PokemonInterface {\n', 'function levels(uint256 _pokemonId) external view returns (\n', 'uint256 level\n', ');\n', '\n', 'function getPokemonOwner(uint _pokemonId)external view returns (\n', 'address currentOwner\n', ');\n', '}\n', '\n', 'contract PublicBattle {\n', 'using SafeMath for uint256;\n', '//Guess parameter\n', 'uint public totalGuess;\n', 'uint public totalPool;\n', 'uint public publicBattlepm1;\n', 'uint public publicBattlepm2;\n', 'address guesser;\n', 'bool public publicbattlestart;\n', 'mapping(uint => address[]) pokemonGuessPlayers;\n', 'mapping(uint => uint) pokemonGuessNumber;\n', 'mapping(uint => uint) pokemonGuessPrize;\n', 'mapping(address => uint) playerGuessPM1Number;\n', 'mapping(address => uint) playerGuessPM2Number;\n', 'mapping(uint => uint) battleCD;\n', 'uint public pbWinner;\n', '\n', 'address cpAddress = 0x77fA1D1Ded3F4bed737e9aE870a6f3605445df9c;\n', 'PokemonInterface pokemonContract = PokemonInterface(cpAddress);\n', '\n', 'address contractCreator;\n', 'address devFeeAddress;\n', '\n', 'function PublicBattle () public {\n', '\n', 'contractCreator = msg.sender;\n', 'devFeeAddress = 0xFb2D26b0caa4C331bd0e101460ec9dbE0A4783A4;\n', 'publicbattlestart = false;\n', 'publicBattlepm1 = 99999;\n', 'publicBattlepm2 = 99999;\n', 'pbWinner = 99999;\n', 'isPaused = false;\n', 'totalPool = 0;\n', 'initialPokemonInfo();\n', '}\n', '\n', 'struct Battlelog {\n', 'uint pokemonId1;\n', 'uint pokemonId2;\n', 'uint result;\n', '\n', '}\n', 'Battlelog[] battleresults;\n', '\n', 'struct PokemonDetails {\n', 'string pokemonName;\n', 'uint pokemonType;\n', 'uint total;\n', '}\n', 'PokemonDetails[] pokemoninfo;\n', '\n', '//modifiers\n', 'modifier onlyContractCreator() {\n', 'require (msg.sender == contractCreator);\n', '_;\n', '}\n', '\n', '\n', '//Owners and admins\n', '\n', '/* Owner */\n', 'function setOwner (address _owner) onlyContractCreator() public {\n', 'contractCreator = _owner;\n', '}\n', '\n', '\n', '// Adresses\n', 'function setdevFeeAddress (address _devFeeAddress) onlyContractCreator() public {\n', 'devFeeAddress = _devFeeAddress;\n', '}\n', '\n', 'bool isPaused;\n', '/*\n', 'When countdowns and events happening, use the checker.\n', '*/\n', 'function pauseGame() public onlyContractCreator {\n', 'isPaused = true;\n', '}\n', 'function unPauseGame() public onlyContractCreator {\n', 'isPaused = false;\n', '}\n', 'function GetGamestatus() public view returns(bool) {\n', 'return(isPaused);\n', '}\n', '\n', '//set withdraw only use when bugs happned.\n', 'function withdrawAmount (uint256 _amount) onlyContractCreator() public {\n', 'msg.sender.transfer(_amount);\n', 'totalPool = totalPool - _amount;\n', '}\n', '\n', 'function initialBattle(uint _pokemonId1,uint _pokemonId2) public{\n', 'require(pokemonContract.getPokemonOwner(_pokemonId1) == msg.sender);\n', 'require(isPaused == false);\n', 'require(_pokemonId1 != _pokemonId2);\n', 'require(getPokemonCD(_pokemonId1) == 0);\n', 'assert(publicbattlestart != true);\n', 'publicBattlepm1 = _pokemonId1;\n', 'publicBattlepm2 = _pokemonId2;\n', 'publicbattlestart = true;\n', 'pokemonGuessNumber[publicBattlepm1]=0;\n', 'pokemonGuessNumber[publicBattlepm2]=0;\n', 'pokemonGuessPrize[publicBattlepm1]=0;\n', 'pokemonGuessPrize[publicBattlepm2]=0;\n', 'isPaused = false;\n', 'battleCD[_pokemonId1] = now + 12 * 1 hours;\n', '// add 1% of balance to contract\n', 'totalGuess = totalPool.div(100);\n', '//trigger time\n', '\n', '}\n', 'function donateToPool() public payable{\n', '// The pool will make this game maintain forever, 1% of prize goto each publicbattle and\n', '// gain 1% of each publicbattle back before distributePrizes\n', 'require(msg.value >= 0);\n', 'totalPool = totalPool + msg.value;\n', '\n', '}\n', '\n', 'function guess(uint _pokemonId) public payable{\n', 'require(isPaused == false);\n', 'assert(msg.value > 0);\n', 'assert(_pokemonId == publicBattlepm1 || _pokemonId == publicBattlepm2);\n', '\n', 'uint256 calcValue = msg.value;\n', 'uint256 cutFee = calcValue.div(16);\n', '\n', 'calcValue = calcValue - cutFee;\n', '\n', '// %3 to the Owner of the card and %3 to dev\n', 'pokemonContract.getPokemonOwner(_pokemonId).transfer(cutFee.div(2));\n', 'devFeeAddress.transfer(cutFee.div(2));\n', '\n', '// Total amount\n', 'totalGuess += calcValue;\n', '\n', '// Each guess time\n', 'pokemonGuessNumber[_pokemonId]++;\n', '\n', '\n', '// Each amount\n', 'pokemonGuessPrize[_pokemonId] = pokemonGuessPrize[_pokemonId] + calcValue;\n', '\n', '\n', '// mapping sender and amount\n', '\n', 'if(_pokemonId == publicBattlepm1){\n', '\n', 'if(playerGuessPM1Number[msg.sender] != 0){\n', '\n', 'playerGuessPM1Number[msg.sender] = playerGuessPM1Number[msg.sender] + calcValue;\n', '\n', '}else{\n', '\n', 'pokemonGuessPlayers[_pokemonId].push(msg.sender);\n', 'playerGuessPM1Number[msg.sender]  = calcValue;\n', '}\n', '\n', '}else{\n', '\n', '\n', 'if(playerGuessPM2Number[msg.sender] != 0){\n', '\n', 'playerGuessPM2Number[msg.sender] = playerGuessPM2Number[msg.sender] + calcValue;\n', '\n', '}else{\n', '\n', 'pokemonGuessPlayers[_pokemonId].push(msg.sender);\n', 'playerGuessPM2Number[msg.sender]  = calcValue;\n', '}\n', '\n', '}\n', '\n', 'if(pokemonGuessNumber[publicBattlepm1] + pokemonGuessNumber[publicBattlepm2] > 20){\n', 'startpublicBattle(publicBattlepm1, publicBattlepm2);\n', '}\n', '\n', '}\n', '\n', 'function startpublicBattle(uint _pokemon1, uint _pokemon2) internal {\n', 'require(publicBattlepm1 != 99999 && publicBattlepm2 != 99999);\n', 'uint256 i = uint256(sha256(block.timestamp, block.number-i-1)) % 100 +1;\n', 'uint256 threshold = dataCalc(_pokemon1, _pokemon2);\n', '\n', 'if(i <= threshold){\n', 'pbWinner = publicBattlepm1;\n', '}else{\n', 'pbWinner = publicBattlepm2;\n', '}\n', 'battleresults.push(Battlelog(_pokemon1,_pokemon2,pbWinner));\n', 'distributePrizes();\n', '\n', '}\n', '\n', 'function distributePrizes() internal{\n', '// return 1% to the balance to keep public battle forever\n', 'totalGuess = totalGuess - totalGuess.div(100);\n', 'for(uint counter=0; counter < pokemonGuessPlayers[pbWinner].length; counter++){\n', 'guesser = pokemonGuessPlayers[pbWinner][counter];\n', 'if(pbWinner == publicBattlepm1){\n', 'guesser.transfer(playerGuessPM1Number[guesser].mul(totalGuess).div(pokemonGuessPrize[pbWinner]));\n', '//delete playerGuessPM1Number[guesser];\n', '\n', '}else{\n', '\n', 'guesser.transfer(playerGuessPM2Number[guesser].mul(totalGuess).div(pokemonGuessPrize[pbWinner]));\n', '\n', '\n', '}\n', '}\n', 'uint del;\n', 'if(pbWinner == publicBattlepm1){\n', 'del = publicBattlepm2;\n', '}else{\n', 'del = publicBattlepm1;\n', '}\n', '\n', 'for(uint cdel1=0; cdel1 < pokemonGuessPlayers[pbWinner].length; cdel1++){\n', 'guesser = pokemonGuessPlayers[pbWinner][cdel1];\n', 'if(pbWinner == publicBattlepm1){\n', 'delete playerGuessPM1Number[guesser];\n', '}else{\n', 'delete playerGuessPM2Number[guesser];\n', '}\n', '}\n', '\n', 'for(uint cdel=0; cdel < pokemonGuessPlayers[del].length; cdel++){\n', 'guesser = pokemonGuessPlayers[del][cdel];\n', 'if(del == publicBattlepm1){\n', 'delete playerGuessPM1Number[guesser];\n', '}else{\n', 'delete playerGuessPM2Number[guesser];\n', '}\n', '}\n', '\n', '\n', 'pokemonGuessNumber[publicBattlepm1]=0;\n', 'pokemonGuessNumber[publicBattlepm2]=0;\n', '\n', 'pokemonGuessPrize[publicBattlepm1]=0;\n', 'pokemonGuessPrize[publicBattlepm2]=0;\n', 'delete pokemonGuessPlayers[publicBattlepm2];\n', 'delete pokemonGuessPlayers[publicBattlepm1];\n', '//for(counter=0; counter < pokemonGuessPlayers[pbWinner].length; counter++){\n', '//pokemonGuessPlayers[counter].length = 0;\n', '//}\n', 'counter = 0;\n', 'publicBattlepm1 = 99999;\n', 'publicBattlepm2 = 99999;\n', 'pbWinner = 99999;\n', 'totalGuess = 0;\n', 'publicbattlestart = false;\n', '}\n', '\n', 'function dataCalc(uint _pokemon1, uint _pokemon2) public view returns (uint256 _threshold){\n', 'uint _pokemontotal1;\n', 'uint _pokemontotal2;\n', '\n', '// We can just leave the other fields blank:\n', '(,,_pokemontotal1) = getPokemonDetails(_pokemon1);\n', '(,,_pokemontotal2) = getPokemonDetails(_pokemon2);\n', 'uint256 threshold = _pokemontotal1.mul(100).div(_pokemontotal1+_pokemontotal2);\n', 'uint256 pokemonlevel1 = pokemonContract.levels(_pokemon1);\n', 'uint256 pokemonlevel2 = pokemonContract.levels(_pokemon2);\n', 'uint leveldiff = pokemonlevel1 - pokemonlevel2;\n', 'if(pokemonlevel1 >= pokemonlevel2){\n', 'threshold = threshold.mul(11**leveldiff).div(10**leveldiff);\n', '\n', '}else{\n', '//return (100 - dataCalc(_pokemon2, _pokemon1));\n', 'threshold = 100 - dataCalc(_pokemon2, _pokemon1);\n', '}\n', 'if(threshold > 90){\n', 'threshold = 90;\n', '}\n', 'if(threshold < 10){\n', 'threshold = 10;\n', '}\n', '\n', 'return threshold;\n', '\n', '}\n', '\n', '\n', '\n', '// This function will return all of the details of the pokemons\n', 'function getBattleDetails(uint _battleId) public view returns (\n', 'uint _pokemon1,\n', 'uint _pokemon2,\n', 'uint256 _result\n', ') {\n', 'Battlelog storage _battle = battleresults[_battleId];\n', '\n', '_pokemon1 = _battle.pokemonId1;\n', '_pokemon2 = _battle.pokemonId2;\n', '_result = _battle.result;\n', '}\n', '\n', 'function addPokemonDetails(string _pokemonName, uint _pokemonType, uint _total) public onlyContractCreator{\n', '\n', 'pokemoninfo.push(PokemonDetails(_pokemonName,_pokemonType,_total));\n', '}\n', '\n', '// This function will return all of the details of the pokemons\n', 'function getPokemonDetails(uint _pokemonId) public view returns (\n', 'string _pokemonName,\n', 'uint _pokemonType,\n', 'uint _total\n', ') {\n', 'PokemonDetails storage _pokemoninfomation = pokemoninfo[_pokemonId];\n', '\n', '_pokemonName = _pokemoninfomation.pokemonName;\n', '_pokemonType = _pokemoninfomation.pokemonType;\n', '_total = _pokemoninfomation.total;\n', '}\n', '\n', 'function totalBattles() public view returns (uint256 _totalSupply) {\n', 'return battleresults.length;\n', '}\n', '\n', 'function getPokemonBet(uint _pokemonId) public view returns (uint256 _pokemonBet){\n', 'return pokemonGuessPrize[_pokemonId];\n', '}\n', '\n', 'function getPokemonOwner(uint _pokemonId) public view returns (\n', 'address _owner\n', ') {\n', '\n', '_owner = pokemonContract.getPokemonOwner(_pokemonId);\n', '\n', '}\n', '\n', 'function getPublicBattlePokemon1() public view returns(uint _pokemonId1){\n', '\n', 'return publicBattlepm1;\n', '}\n', 'function getPublicBattlePokemon2() public view returns(uint _pokemonId1){\n', '\n', 'return publicBattlepm2;\n', '}\n', '\n', 'function getPokemonBetTimes(uint _pokemonId) public view returns(uint _pokemonBetTimes){\n', '\n', 'return pokemonGuessNumber[_pokemonId];\n', '}\n', '\n', 'function getPokemonCD(uint _pokemonId) public view returns(uint _pokemonCD){\n', 'if(battleCD[_pokemonId] <= now){\n', 'return 0;\n', '}else{\n', 'return battleCD[_pokemonId] - now;\n', '}\n', '}\n', '\n', 'function initialPokemonInfo() public onlyContractCreator{\n', 'addPokemonDetails("PikaChu" ,1, 300);\n', 'addPokemonDetails("Ninetales",1,505);\n', 'addPokemonDetails("Charizard" ,2, 534);\n', 'addPokemonDetails("Eevee",0,325);\n', 'addPokemonDetails("Jigglypuff" ,0, 270);\n', 'addPokemonDetails("Pidgeot",2,469);\n', 'addPokemonDetails("Aerodactyl" ,2, 515);\n', 'addPokemonDetails("Bulbasaur",0,318);\n', 'addPokemonDetails("Abra" ,0, 310);\n', 'addPokemonDetails("Gengar",2,500);\n', 'addPokemonDetails("Hoothoot" ,0, 262);\n', 'addPokemonDetails("Goldeen",0,320);\n', '\n', '}\n', '\n', '}']
['pragma solidity ^0.4.19;\n', '/*\n', 'Game: CryptoPokemon\n', 'Domain: CryptoPokemon.com\n', 'Dev: CryptoPokemon Team\n', '*/\n', '\n', 'library SafeMath {\n', '\n', '/**\n', '* @dev Multiplies two numbers, throws on overflow.\n', '*/\n', 'function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', 'if (a == 0) {\n', 'return 0;\n', '}\n', 'uint256 c = a * b;\n', 'assert(c / a == b);\n', 'return c;\n', '}\n', '\n', '/**\n', '* @dev Integer division of two numbers, truncating the quotient.\n', '*/\n', 'function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '// assert(b > 0); // Solidity automatically throws when dividing by 0\n', 'uint256 c = a / b;\n', "// assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", 'return c;\n', '}\n', '\n', '/**\n', '* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '*/\n', 'function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', 'assert(b <= a);\n', 'return a - b;\n', '}\n', '\n', '/**\n', '* @dev Adds two numbers, throws on overflow.\n', '*/\n', 'function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', 'uint256 c = a + b;\n', 'assert(c >= a);\n', 'return c;\n', '}\n', '}\n', '\n', 'contract PokemonInterface {\n', 'function levels(uint256 _pokemonId) external view returns (\n', 'uint256 level\n', ');\n', '\n', 'function getPokemonOwner(uint _pokemonId)external view returns (\n', 'address currentOwner\n', ');\n', '}\n', '\n', 'contract PublicBattle {\n', 'using SafeMath for uint256;\n', '//Guess parameter\n', 'uint public totalGuess;\n', 'uint public totalPool;\n', 'uint public publicBattlepm1;\n', 'uint public publicBattlepm2;\n', 'address guesser;\n', 'bool public publicbattlestart;\n', 'mapping(uint => address[]) pokemonGuessPlayers;\n', 'mapping(uint => uint) pokemonGuessNumber;\n', 'mapping(uint => uint) pokemonGuessPrize;\n', 'mapping(address => uint) playerGuessPM1Number;\n', 'mapping(address => uint) playerGuessPM2Number;\n', 'mapping(uint => uint) battleCD;\n', 'uint public pbWinner;\n', '\n', 'address cpAddress = 0x77fA1D1Ded3F4bed737e9aE870a6f3605445df9c;\n', 'PokemonInterface pokemonContract = PokemonInterface(cpAddress);\n', '\n', 'address contractCreator;\n', 'address devFeeAddress;\n', '\n', 'function PublicBattle () public {\n', '\n', 'contractCreator = msg.sender;\n', 'devFeeAddress = 0xFb2D26b0caa4C331bd0e101460ec9dbE0A4783A4;\n', 'publicbattlestart = false;\n', 'publicBattlepm1 = 99999;\n', 'publicBattlepm2 = 99999;\n', 'pbWinner = 99999;\n', 'isPaused = false;\n', 'totalPool = 0;\n', 'initialPokemonInfo();\n', '}\n', '\n', 'struct Battlelog {\n', 'uint pokemonId1;\n', 'uint pokemonId2;\n', 'uint result;\n', '\n', '}\n', 'Battlelog[] battleresults;\n', '\n', 'struct PokemonDetails {\n', 'string pokemonName;\n', 'uint pokemonType;\n', 'uint total;\n', '}\n', 'PokemonDetails[] pokemoninfo;\n', '\n', '//modifiers\n', 'modifier onlyContractCreator() {\n', 'require (msg.sender == contractCreator);\n', '_;\n', '}\n', '\n', '\n', '//Owners and admins\n', '\n', '/* Owner */\n', 'function setOwner (address _owner) onlyContractCreator() public {\n', 'contractCreator = _owner;\n', '}\n', '\n', '\n', '// Adresses\n', 'function setdevFeeAddress (address _devFeeAddress) onlyContractCreator() public {\n', 'devFeeAddress = _devFeeAddress;\n', '}\n', '\n', 'bool isPaused;\n', '/*\n', 'When countdowns and events happening, use the checker.\n', '*/\n', 'function pauseGame() public onlyContractCreator {\n', 'isPaused = true;\n', '}\n', 'function unPauseGame() public onlyContractCreator {\n', 'isPaused = false;\n', '}\n', 'function GetGamestatus() public view returns(bool) {\n', 'return(isPaused);\n', '}\n', '\n', '//set withdraw only use when bugs happned.\n', 'function withdrawAmount (uint256 _amount) onlyContractCreator() public {\n', 'msg.sender.transfer(_amount);\n', 'totalPool = totalPool - _amount;\n', '}\n', '\n', 'function initialBattle(uint _pokemonId1,uint _pokemonId2) public{\n', 'require(pokemonContract.getPokemonOwner(_pokemonId1) == msg.sender);\n', 'require(isPaused == false);\n', 'require(_pokemonId1 != _pokemonId2);\n', 'require(getPokemonCD(_pokemonId1) == 0);\n', 'assert(publicbattlestart != true);\n', 'publicBattlepm1 = _pokemonId1;\n', 'publicBattlepm2 = _pokemonId2;\n', 'publicbattlestart = true;\n', 'pokemonGuessNumber[publicBattlepm1]=0;\n', 'pokemonGuessNumber[publicBattlepm2]=0;\n', 'pokemonGuessPrize[publicBattlepm1]=0;\n', 'pokemonGuessPrize[publicBattlepm2]=0;\n', 'isPaused = false;\n', 'battleCD[_pokemonId1] = now + 12 * 1 hours;\n', '// add 1% of balance to contract\n', 'totalGuess = totalPool.div(100);\n', '//trigger time\n', '\n', '}\n', 'function donateToPool() public payable{\n', '// The pool will make this game maintain forever, 1% of prize goto each publicbattle and\n', '// gain 1% of each publicbattle back before distributePrizes\n', 'require(msg.value >= 0);\n', 'totalPool = totalPool + msg.value;\n', '\n', '}\n', '\n', 'function guess(uint _pokemonId) public payable{\n', 'require(isPaused == false);\n', 'assert(msg.value > 0);\n', 'assert(_pokemonId == publicBattlepm1 || _pokemonId == publicBattlepm2);\n', '\n', 'uint256 calcValue = msg.value;\n', 'uint256 cutFee = calcValue.div(16);\n', '\n', 'calcValue = calcValue - cutFee;\n', '\n', '// %3 to the Owner of the card and %3 to dev\n', 'pokemonContract.getPokemonOwner(_pokemonId).transfer(cutFee.div(2));\n', 'devFeeAddress.transfer(cutFee.div(2));\n', '\n', '// Total amount\n', 'totalGuess += calcValue;\n', '\n', '// Each guess time\n', 'pokemonGuessNumber[_pokemonId]++;\n', '\n', '\n', '// Each amount\n', 'pokemonGuessPrize[_pokemonId] = pokemonGuessPrize[_pokemonId] + calcValue;\n', '\n', '\n', '// mapping sender and amount\n', '\n', 'if(_pokemonId == publicBattlepm1){\n', '\n', 'if(playerGuessPM1Number[msg.sender] != 0){\n', '\n', 'playerGuessPM1Number[msg.sender] = playerGuessPM1Number[msg.sender] + calcValue;\n', '\n', '}else{\n', '\n', 'pokemonGuessPlayers[_pokemonId].push(msg.sender);\n', 'playerGuessPM1Number[msg.sender]  = calcValue;\n', '}\n', '\n', '}else{\n', '\n', '\n', 'if(playerGuessPM2Number[msg.sender] != 0){\n', '\n', 'playerGuessPM2Number[msg.sender] = playerGuessPM2Number[msg.sender] + calcValue;\n', '\n', '}else{\n', '\n', 'pokemonGuessPlayers[_pokemonId].push(msg.sender);\n', 'playerGuessPM2Number[msg.sender]  = calcValue;\n', '}\n', '\n', '}\n', '\n', 'if(pokemonGuessNumber[publicBattlepm1] + pokemonGuessNumber[publicBattlepm2] > 20){\n', 'startpublicBattle(publicBattlepm1, publicBattlepm2);\n', '}\n', '\n', '}\n', '\n', 'function startpublicBattle(uint _pokemon1, uint _pokemon2) internal {\n', 'require(publicBattlepm1 != 99999 && publicBattlepm2 != 99999);\n', 'uint256 i = uint256(sha256(block.timestamp, block.number-i-1)) % 100 +1;\n', 'uint256 threshold = dataCalc(_pokemon1, _pokemon2);\n', '\n', 'if(i <= threshold){\n', 'pbWinner = publicBattlepm1;\n', '}else{\n', 'pbWinner = publicBattlepm2;\n', '}\n', 'battleresults.push(Battlelog(_pokemon1,_pokemon2,pbWinner));\n', 'distributePrizes();\n', '\n', '}\n', '\n', 'function distributePrizes() internal{\n', '// return 1% to the balance to keep public battle forever\n', 'totalGuess = totalGuess - totalGuess.div(100);\n', 'for(uint counter=0; counter < pokemonGuessPlayers[pbWinner].length; counter++){\n', 'guesser = pokemonGuessPlayers[pbWinner][counter];\n', 'if(pbWinner == publicBattlepm1){\n', 'guesser.transfer(playerGuessPM1Number[guesser].mul(totalGuess).div(pokemonGuessPrize[pbWinner]));\n', '//delete playerGuessPM1Number[guesser];\n', '\n', '}else{\n', '\n', 'guesser.transfer(playerGuessPM2Number[guesser].mul(totalGuess).div(pokemonGuessPrize[pbWinner]));\n', '\n', '\n', '}\n', '}\n', 'uint del;\n', 'if(pbWinner == publicBattlepm1){\n', 'del = publicBattlepm2;\n', '}else{\n', 'del = publicBattlepm1;\n', '}\n', '\n', 'for(uint cdel1=0; cdel1 < pokemonGuessPlayers[pbWinner].length; cdel1++){\n', 'guesser = pokemonGuessPlayers[pbWinner][cdel1];\n', 'if(pbWinner == publicBattlepm1){\n', 'delete playerGuessPM1Number[guesser];\n', '}else{\n', 'delete playerGuessPM2Number[guesser];\n', '}\n', '}\n', '\n', 'for(uint cdel=0; cdel < pokemonGuessPlayers[del].length; cdel++){\n', 'guesser = pokemonGuessPlayers[del][cdel];\n', 'if(del == publicBattlepm1){\n', 'delete playerGuessPM1Number[guesser];\n', '}else{\n', 'delete playerGuessPM2Number[guesser];\n', '}\n', '}\n', '\n', '\n', 'pokemonGuessNumber[publicBattlepm1]=0;\n', 'pokemonGuessNumber[publicBattlepm2]=0;\n', '\n', 'pokemonGuessPrize[publicBattlepm1]=0;\n', 'pokemonGuessPrize[publicBattlepm2]=0;\n', 'delete pokemonGuessPlayers[publicBattlepm2];\n', 'delete pokemonGuessPlayers[publicBattlepm1];\n', '//for(counter=0; counter < pokemonGuessPlayers[pbWinner].length; counter++){\n', '//pokemonGuessPlayers[counter].length = 0;\n', '//}\n', 'counter = 0;\n', 'publicBattlepm1 = 99999;\n', 'publicBattlepm2 = 99999;\n', 'pbWinner = 99999;\n', 'totalGuess = 0;\n', 'publicbattlestart = false;\n', '}\n', '\n', 'function dataCalc(uint _pokemon1, uint _pokemon2) public view returns (uint256 _threshold){\n', 'uint _pokemontotal1;\n', 'uint _pokemontotal2;\n', '\n', '// We can just leave the other fields blank:\n', '(,,_pokemontotal1) = getPokemonDetails(_pokemon1);\n', '(,,_pokemontotal2) = getPokemonDetails(_pokemon2);\n', 'uint256 threshold = _pokemontotal1.mul(100).div(_pokemontotal1+_pokemontotal2);\n', 'uint256 pokemonlevel1 = pokemonContract.levels(_pokemon1);\n', 'uint256 pokemonlevel2 = pokemonContract.levels(_pokemon2);\n', 'uint leveldiff = pokemonlevel1 - pokemonlevel2;\n', 'if(pokemonlevel1 >= pokemonlevel2){\n', 'threshold = threshold.mul(11**leveldiff).div(10**leveldiff);\n', '\n', '}else{\n', '//return (100 - dataCalc(_pokemon2, _pokemon1));\n', 'threshold = 100 - dataCalc(_pokemon2, _pokemon1);\n', '}\n', 'if(threshold > 90){\n', 'threshold = 90;\n', '}\n', 'if(threshold < 10){\n', 'threshold = 10;\n', '}\n', '\n', 'return threshold;\n', '\n', '}\n', '\n', '\n', '\n', '// This function will return all of the details of the pokemons\n', 'function getBattleDetails(uint _battleId) public view returns (\n', 'uint _pokemon1,\n', 'uint _pokemon2,\n', 'uint256 _result\n', ') {\n', 'Battlelog storage _battle = battleresults[_battleId];\n', '\n', '_pokemon1 = _battle.pokemonId1;\n', '_pokemon2 = _battle.pokemonId2;\n', '_result = _battle.result;\n', '}\n', '\n', 'function addPokemonDetails(string _pokemonName, uint _pokemonType, uint _total) public onlyContractCreator{\n', '\n', 'pokemoninfo.push(PokemonDetails(_pokemonName,_pokemonType,_total));\n', '}\n', '\n', '// This function will return all of the details of the pokemons\n', 'function getPokemonDetails(uint _pokemonId) public view returns (\n', 'string _pokemonName,\n', 'uint _pokemonType,\n', 'uint _total\n', ') {\n', 'PokemonDetails storage _pokemoninfomation = pokemoninfo[_pokemonId];\n', '\n', '_pokemonName = _pokemoninfomation.pokemonName;\n', '_pokemonType = _pokemoninfomation.pokemonType;\n', '_total = _pokemoninfomation.total;\n', '}\n', '\n', 'function totalBattles() public view returns (uint256 _totalSupply) {\n', 'return battleresults.length;\n', '}\n', '\n', 'function getPokemonBet(uint _pokemonId) public view returns (uint256 _pokemonBet){\n', 'return pokemonGuessPrize[_pokemonId];\n', '}\n', '\n', 'function getPokemonOwner(uint _pokemonId) public view returns (\n', 'address _owner\n', ') {\n', '\n', '_owner = pokemonContract.getPokemonOwner(_pokemonId);\n', '\n', '}\n', '\n', 'function getPublicBattlePokemon1() public view returns(uint _pokemonId1){\n', '\n', 'return publicBattlepm1;\n', '}\n', 'function getPublicBattlePokemon2() public view returns(uint _pokemonId1){\n', '\n', 'return publicBattlepm2;\n', '}\n', '\n', 'function getPokemonBetTimes(uint _pokemonId) public view returns(uint _pokemonBetTimes){\n', '\n', 'return pokemonGuessNumber[_pokemonId];\n', '}\n', '\n', 'function getPokemonCD(uint _pokemonId) public view returns(uint _pokemonCD){\n', 'if(battleCD[_pokemonId] <= now){\n', 'return 0;\n', '}else{\n', 'return battleCD[_pokemonId] - now;\n', '}\n', '}\n', '\n', 'function initialPokemonInfo() public onlyContractCreator{\n', 'addPokemonDetails("PikaChu" ,1, 300);\n', 'addPokemonDetails("Ninetales",1,505);\n', 'addPokemonDetails("Charizard" ,2, 534);\n', 'addPokemonDetails("Eevee",0,325);\n', 'addPokemonDetails("Jigglypuff" ,0, 270);\n', 'addPokemonDetails("Pidgeot",2,469);\n', 'addPokemonDetails("Aerodactyl" ,2, 515);\n', 'addPokemonDetails("Bulbasaur",0,318);\n', 'addPokemonDetails("Abra" ,0, 310);\n', 'addPokemonDetails("Gengar",2,500);\n', 'addPokemonDetails("Hoothoot" ,0, 262);\n', 'addPokemonDetails("Goldeen",0,320);\n', '\n', '}\n', '\n', '}']