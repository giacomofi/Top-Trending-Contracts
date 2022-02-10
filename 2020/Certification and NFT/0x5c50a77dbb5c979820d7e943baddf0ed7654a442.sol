['pragma solidity 0.4.25;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '    return c;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '  function totalSupply() pure public returns (uint256 supply);\n', '  function balanceOf(address _owner) pure public returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '  function approve(address _spender, uint256 _value) public returns (bool success);\n', '  function allowance(address _owner, address _spender) pure public returns (uint256 remaining);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '  uint public decimals;\n', '  string public name;\n', '}\n', '\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  constructor() internal {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), _owner);\n', '  }\n', '\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipTransferred(_owner, address(0));\n', '    _owner = address(0);\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract LockedResources is Ownable {\n', '  address public tokenAddress;\n', '  Token public token;\n', '\n', '  uint256 public VaultCreation = now;\n', '\n', '  constructor() public{\n', '    tokenAddress = 0x5DE4f909F416013558b69FA2b78E99739b61c83d;\n', '    token = Token(tokenAddress); \n', '  } \n', '  \n', '  function refundAll() onlyOwner public{\n', '    require(now > VaultCreation + 60 days); \n', '    token.transfer(owner(), token.balanceOf(this));  \n', '  }\n', '  \n', '}']