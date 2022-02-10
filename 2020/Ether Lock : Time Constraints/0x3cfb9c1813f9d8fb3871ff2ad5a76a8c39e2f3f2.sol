['pragma solidity 0.4.25;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '    return c;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '  function totalSupply() pure public returns (uint256 supply);\n', '  function balanceOf(address _owner) pure public returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '  function approve(address _spender, uint256 _value) public returns (bool success);\n', '  function allowance(address _owner, address _spender) pure public returns (uint256 remaining);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '  uint public decimals;\n', '  string public name;\n', '}\n', '\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  constructor() internal {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), _owner);\n', '  }\n', '\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipTransferred(_owner, address(0));\n', '    _owner = address(0);\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract TimeFarmerPool is Ownable {\n', '    \n', '  uint256 constant public TOKEN_PRECISION = 1e6;\n', '  uint256 constant private PRECISION = 1e12;  \n', '  uint256 constant private REBASE_TIME = 1 hours; \n', '\t\n', '  Token public liqudityToken;\n', '  Token public farmToken;\n', '  \n', '  struct User {\n', '        uint256 liqudityBalance;\n', '        uint256 appliedFarmTokenCirculation;\n', '  }\n', '    \n', '  struct Info {\n', '        uint256 totalFarmSupply;\n', '        \n', '        mapping(address => User) users;\n', '        address admin;\n', '        \n', '        uint256 coinWorkingTime;\n', '        uint256 coinCreationTime;\n', '  }\n', '    \n', '  Info private info;\n', '\n', '  address public liqudityTokenAddress;\n', '  address public farmTokenAddress;\n', '  uint256 public VaultCreation = now;\n', '  \n', '  mapping(uint256 => uint256) public historyOfLiqudity;\n', '      \n', '    uint256 public testPosition;\n', '  \n', '  constructor() public{\n', '      \n', '    info.coinWorkingTime = now;\n', '\tinfo.coinCreationTime = now;\n', '\t\n', '\tliqudityTokenAddress = 0x5DE4f909F416013558b69FA2b78E99739b61c83d;\n', '\tfarmTokenAddress = 0x63A6da104C6a08dfeB50D13a7488F67bC98Cc41f;\n', '\t    \n', '    liqudityToken = Token(liqudityTokenAddress); \n', '    farmToken = Token(farmTokenAddress);\n', '    \n', '    info.totalFarmSupply = 1 * TOKEN_PRECISION;\n', '  } \n', '  \n', '  function joinFarmPool(uint256 liqudityTokenToFarm) public payable {\n', '      \n', '    uint256 userBalance = liqudityToken.balanceOf(msg.sender);\n', '   \n', '    require(userBalance >= liqudityTokenToFarm, "Insufficient tokens");\n', '    \n', '    bool isNewUser = info.users[msg.sender].liqudityBalance == 0;\n', '\n', '\tif(isNewUser)\n', '\t{\n', '\t    liqudityToken.transferFrom(msg.sender, address(this), liqudityTokenToFarm);\n', '\t    adjustTime();\n', '\t    info.users[msg.sender].appliedFarmTokenCirculation = info.totalFarmSupply;\n', '\t}\n', '\telse\n', '\t{\n', '\t    claimTokens();\n', '\t    liqudityToken.transferFrom(msg.sender, address(this), liqudityTokenToFarm);\n', '\t}\n', '    \n', '    info.users[msg.sender].liqudityBalance += liqudityTokenToFarm;\n', '  }\n', '  \n', '  function leaveFarmPool(uint256 liqudityTokenFromFarm) public payable {\n', '      \n', '    uint256 userBalanceInPool = info.users[msg.sender].liqudityBalance;\n', '   \n', '    require(userBalanceInPool >= liqudityTokenFromFarm, "Insufficient tokens");\n', '    \n', '    claimTokens();\n', '    \n', '    liqudityToken.transfer(msg.sender, liqudityTokenFromFarm); \n', '    \n', '    info.users[msg.sender].liqudityBalance -= liqudityTokenFromFarm;\n', '    \n', '  }\n', '\n', '  function adjustTime() private {\n', '    if(info.coinWorkingTime + REBASE_TIME < now)\n', '    {\n', '        uint256 countOfCoinsToAdd = ((now - info.coinCreationTime) / REBASE_TIME);\n', '        info.coinWorkingTime = now;\n', '        info.totalFarmSupply = (countOfCoinsToAdd * TOKEN_PRECISION); \n', '    }\n', '    \n', '    uint256 position = info.totalFarmSupply / TOKEN_PRECISION;\n', '    testPosition = position;\n', '    historyOfLiqudity[position] = liqudityToken.balanceOf(address(this));\n', '  }\n', '  \n', '  function claimTokens() public payable {\n', '    adjustTime();\n', '    \n', '    uint256 valueFromLiqudityHistory = info.users[msg.sender].appliedFarmTokenCirculation / TOKEN_PRECISION;\n', '    uint256 valueToLiqudityHistory = info.totalFarmSupply / TOKEN_PRECISION;\n', '    \n', '    uint256 farmTokenToClaim = 0;\n', '    for (uint i=valueFromLiqudityHistory; i<valueToLiqudityHistory; i++) {\n', '        \n', '        if(historyOfLiqudity[i] == 0){\n', '            historyOfLiqudity[i] = historyOfLiqudity[i - 1];\n', '        }\n', '        \n', '        farmTokenToClaim += ((TOKEN_PRECISION * info.users[msg.sender].liqudityBalance) / historyOfLiqudity[i]); \n', '    }\n', '    \n', '    farmToken.transfer(msg.sender, farmTokenToClaim); \n', '    \n', '    info.users[msg.sender].appliedFarmTokenCirculation = info.totalFarmSupply;\n', '  }\n', '  \n', ' \n', '  // Views\n', '  function tokensToClaim(address _user)  public view returns (uint256 tokensToTake) {\n', '    uint256 countOfCoinsToAdd = ((now - info.coinCreationTime) / REBASE_TIME);\n', '      \n', '    uint256 realTotalSupply = (countOfCoinsToAdd * TOKEN_PRECISION); \n', '        \n', '    uint256 valueFromLiqudityHistory = info.users[_user].appliedFarmTokenCirculation / TOKEN_PRECISION;\n', '    uint256 valueToLiqudityHistory = realTotalSupply / TOKEN_PRECISION;\n', '    \n', '    uint256[] memory myArray = new uint256[](valueToLiqudityHistory - valueFromLiqudityHistory);\n', '    uint counter = 0;\n', '    for (uint i=valueFromLiqudityHistory; i<valueToLiqudityHistory; i++) {\n', '        myArray[counter] = historyOfLiqudity[i];\n', '        if(historyOfLiqudity[i] == 0){\n', '            myArray[counter] = myArray[counter-1];\n', '        }\n', '        counter++;\n', '    }\n', '    \n', '    uint256 adjustedAddressBalance = 0;\n', '    for (uint j=0; j<counter; j++) {\n', '        adjustedAddressBalance += ((TOKEN_PRECISION * info.users[_user].liqudityBalance) / myArray[j]); \n', '    }\n', '    \n', '     return adjustedAddressBalance;\n', '  }\n', '  \n', '   function allMintedTokens()  public view returns (uint256 mintedTokens) {\n', '      uint256 countOfCoinsToAdd = ((now - info.coinCreationTime) / REBASE_TIME);\n', '      uint256 allMintedTokensFromFarm = (countOfCoinsToAdd * TOKEN_PRECISION); \n', '      return allMintedTokensFromFarm;\n', '  }\n', '  \n', '  function allInfoFor(address _user) public view returns (\n', '      uint256 totalFarmSupply,\n', '      uint256 allFarmTokens, \n', '      uint256 allLiquidityTokens,\n', '      uint256 myLiqudityInContract,\n', '      uint256 allFarmTokensContract, \n', '      uint256 allLiquidityTokensontract,\n', '      uint256 lockedLiqudityInContract\n', '      ) {\n', '\treturn (\n', '\tinfo.totalFarmSupply, \n', '\tfarmToken.balanceOf(_user), //metamask\n', '\tliqudityToken.balanceOf(_user), //metamask\n', '\tinfo.users[_user].liqudityBalance, //locked in contract\n', '\tfarmToken.balanceOf(address(this)), //contract farm tokens\n', '\tliqudityToken.balanceOf(address(this)), //liqudity tokens\n', '\tinfo.users[address(this)].liqudityBalance\n', '\t);\n', '  }\n', '\t\n', '\t\n', '  // Liqudity tokens dropped to contract not using functions so it lock itself\n', '  // Farm tokens dropped to contract not using functions so it lock itself\n', '  \n', '  function refundAll() onlyOwner public{\n', '    require(now > VaultCreation + 365 days); \n', '    farmToken.transfer(owner(), farmToken.balanceOf(this));  \n', '    liqudityToken.transfer(owner(), liqudityToken.balanceOf(this)); \n', '  }\n', '}']