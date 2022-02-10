['//\n', '// compiler: 0.4.21+commit.dfe3193c.Emscripten.clang\n', '//\n', 'pragma solidity ^0.4.21;\n', '\n', 'contract owned {\n', '  address public owner;\n', '  function owned() public { owner = msg.sender; }\n', '\n', '  modifier onlyOwner {\n', '    if (msg.sender != owner) { revert(); }\n', '    _;\n', '  }\n', '\n', '  function changeOwner( address newown ) public onlyOwner { owner = newown; }\n', '  function closedown() public onlyOwner { selfdestruct( owner ); }\n', '}\n', '\n', '// token sold by this contract must be ERC20-compliant\n', 'interface ERC20 {\n', '  function transfer(address to, uint256 value) external;\n', '  function balanceOf( address owner ) external constant returns (uint);\n', '}\n', '\n', 'contract ICO is owned {\n', '\n', '  ERC20 public tokenSC;\n', '  address      treasury;\n', '  uint public  start;     // seconds since Jan 1 1970 GMT\n', '  uint public  duration;  // seconds\n', '  uint public  tokpereth; // rate, price\n', '  uint public  minfinney; // enforce minimum spend to buy tokens\n', '\n', '  function ICO( address _erc20,\n', '                address _treasury,\n', '                uint _startSec,\n', '                uint _durationSec,\n', '                uint _tokpereth ) public\n', '  {\n', '    require( isContract(_erc20) );\n', '    require( _tokpereth > 0 );\n', '\n', '    if (_treasury != address(0)) require( isContract(_treasury) );\n', '\n', '    tokenSC = ERC20( _erc20 );\n', '    treasury = _treasury;\n', '    start = _startSec;\n', '    duration = _durationSec;\n', '    tokpereth = _tokpereth;\n', '    minfinney = 25;\n', '  }\n', '\n', '  function setToken( address erc ) public onlyOwner { tokenSC = ERC20(erc); }\n', '  function setTreasury( address treas ) public onlyOwner { treasury = treas; }\n', '  function setStart( uint newstart ) public onlyOwner { start = newstart; }\n', '  function setDuration( uint dur ) public onlyOwner { duration = dur; }\n', '  function setRate( uint rate ) public onlyOwner { tokpereth = rate; }\n', '  function setMinimum( uint newmin ) public onlyOwner { minfinney = newmin; }\n', '\n', '  function() public payable {\n', '    require( msg.value >= minfinney );\n', '    if (now < start || now > (start + duration)) revert();\n', '\n', '    // quantity =\n', '    //   amountinwei * tokpereth/weipereth * (bonus+100)/100\n', '    // = amountinwei * tokpereth/1e18 * (bonus+100)/100\n', '    // = msg.value * tokpereth/1e20 * (bonus+100)\n', '\n', '    // NOTE: this calculation does not take decimals into account, because\n', '    //       in MOB case there aren&#39;t any (decimals == 0)\n', '    uint qty =\n', '      multiply( divide( multiply( msg.value,\n', '                                  tokpereth ),\n', '                        1e20),\n', '                (bonus() + 100) );\n', '\n', '    if (qty > tokenSC.balanceOf(address(this)) || qty < 1)\n', '      revert();\n', '\n', '    tokenSC.transfer( msg.sender, qty );\n', '\n', '    if (treasury != address(0)) treasury.transfer( msg.value );\n', '  }\n', '\n', '  // unsold tokens can be claimed by owner after sale ends\n', '  function claimUnsold() public onlyOwner {\n', '    if ( now < (start + duration) ) revert();\n', '\n', '    tokenSC.transfer( owner, tokenSC.balanceOf(address(this)) );\n', '  }\n', '\n', '  function withdraw( uint amount ) public onlyOwner returns (bool) {\n', '    require ( treasury == address(0) && amount <= address(this).balance );\n', '    return owner.send( amount );\n', '  }\n', '\n', '  // edited : no bonus scheme this ICO\n', '  function bonus() pure private returns(uint) { return 0; }\n', '\n', '  function isContract( address _a ) constant private returns (bool) {\n', '    uint ecs;\n', '    assembly { ecs := extcodesize(_a) }\n', '    return ecs > 0;\n', '  }\n', '\n', '  // ref: github.com/OpenZeppelin/zeppelin-solidity/\n', '  //      blob/master/contracts/math/SafeMath.sol\n', '  function multiply(uint256 a, uint256 b) pure private returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function divide(uint256 a, uint256 b) pure private returns (uint256) {\n', '    return a / b;\n', '  }\n', '}']
['//\n', '// compiler: 0.4.21+commit.dfe3193c.Emscripten.clang\n', '//\n', 'pragma solidity ^0.4.21;\n', '\n', 'contract owned {\n', '  address public owner;\n', '  function owned() public { owner = msg.sender; }\n', '\n', '  modifier onlyOwner {\n', '    if (msg.sender != owner) { revert(); }\n', '    _;\n', '  }\n', '\n', '  function changeOwner( address newown ) public onlyOwner { owner = newown; }\n', '  function closedown() public onlyOwner { selfdestruct( owner ); }\n', '}\n', '\n', '// token sold by this contract must be ERC20-compliant\n', 'interface ERC20 {\n', '  function transfer(address to, uint256 value) external;\n', '  function balanceOf( address owner ) external constant returns (uint);\n', '}\n', '\n', 'contract ICO is owned {\n', '\n', '  ERC20 public tokenSC;\n', '  address      treasury;\n', '  uint public  start;     // seconds since Jan 1 1970 GMT\n', '  uint public  duration;  // seconds\n', '  uint public  tokpereth; // rate, price\n', '  uint public  minfinney; // enforce minimum spend to buy tokens\n', '\n', '  function ICO( address _erc20,\n', '                address _treasury,\n', '                uint _startSec,\n', '                uint _durationSec,\n', '                uint _tokpereth ) public\n', '  {\n', '    require( isContract(_erc20) );\n', '    require( _tokpereth > 0 );\n', '\n', '    if (_treasury != address(0)) require( isContract(_treasury) );\n', '\n', '    tokenSC = ERC20( _erc20 );\n', '    treasury = _treasury;\n', '    start = _startSec;\n', '    duration = _durationSec;\n', '    tokpereth = _tokpereth;\n', '    minfinney = 25;\n', '  }\n', '\n', '  function setToken( address erc ) public onlyOwner { tokenSC = ERC20(erc); }\n', '  function setTreasury( address treas ) public onlyOwner { treasury = treas; }\n', '  function setStart( uint newstart ) public onlyOwner { start = newstart; }\n', '  function setDuration( uint dur ) public onlyOwner { duration = dur; }\n', '  function setRate( uint rate ) public onlyOwner { tokpereth = rate; }\n', '  function setMinimum( uint newmin ) public onlyOwner { minfinney = newmin; }\n', '\n', '  function() public payable {\n', '    require( msg.value >= minfinney );\n', '    if (now < start || now > (start + duration)) revert();\n', '\n', '    // quantity =\n', '    //   amountinwei * tokpereth/weipereth * (bonus+100)/100\n', '    // = amountinwei * tokpereth/1e18 * (bonus+100)/100\n', '    // = msg.value * tokpereth/1e20 * (bonus+100)\n', '\n', '    // NOTE: this calculation does not take decimals into account, because\n', "    //       in MOB case there aren't any (decimals == 0)\n", '    uint qty =\n', '      multiply( divide( multiply( msg.value,\n', '                                  tokpereth ),\n', '                        1e20),\n', '                (bonus() + 100) );\n', '\n', '    if (qty > tokenSC.balanceOf(address(this)) || qty < 1)\n', '      revert();\n', '\n', '    tokenSC.transfer( msg.sender, qty );\n', '\n', '    if (treasury != address(0)) treasury.transfer( msg.value );\n', '  }\n', '\n', '  // unsold tokens can be claimed by owner after sale ends\n', '  function claimUnsold() public onlyOwner {\n', '    if ( now < (start + duration) ) revert();\n', '\n', '    tokenSC.transfer( owner, tokenSC.balanceOf(address(this)) );\n', '  }\n', '\n', '  function withdraw( uint amount ) public onlyOwner returns (bool) {\n', '    require ( treasury == address(0) && amount <= address(this).balance );\n', '    return owner.send( amount );\n', '  }\n', '\n', '  // edited : no bonus scheme this ICO\n', '  function bonus() pure private returns(uint) { return 0; }\n', '\n', '  function isContract( address _a ) constant private returns (bool) {\n', '    uint ecs;\n', '    assembly { ecs := extcodesize(_a) }\n', '    return ecs > 0;\n', '  }\n', '\n', '  // ref: github.com/OpenZeppelin/zeppelin-solidity/\n', '  //      blob/master/contracts/math/SafeMath.sol\n', '  function multiply(uint256 a, uint256 b) pure private returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function divide(uint256 a, uint256 b) pure private returns (uint256) {\n', '    return a / b;\n', '  }\n', '}']
