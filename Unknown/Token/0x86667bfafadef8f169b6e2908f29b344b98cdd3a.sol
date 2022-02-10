['pragma solidity ^0.4.9; \n', ' library SafeMath { \n', ' function mul(uint256 a, uint256 b) internal constant returns (uint256) { uint256 c = a * b; assert(a == 0 || c / a == b); return c; } \n', ' function div(uint256 a, uint256 b) internal constant returns (uint256) { uint256 c = a / b; return c; } \n', ' function sub(uint256 a, uint256 b) internal constant returns (uint256) { assert(b <= a); return a - b; } \n', ' function add(uint256 a, uint256 b) internal constant returns (uint256) { uint256 c = a + b; assert(c >= a); return c; } \n', '} \n', ' contract MaxCoin { using SafeMath for uint256; mapping (address => mapping (address => uint256)) allowed; mapping(address => uint256) balances; uint256 public totalSupply; uint256 public decimals; address public owner; bytes32 public symbol; \n', ' event Transfer(address indexed from, address indexed to, uint256 value); \n', ' event Approval(address indexed _owner, address indexed spender, uint256 value); \n', ' function MaxCoin(){ totalSupply = 10000000; symbol = &#39;MaxCoin&#39;; owner =0x70f7edb8b3ef4425ad535d6dd2df074ceb2728b3; balances[owner] = totalSupply; decimals = 0; } \n', ' function balanceOf(address _owner) constant returns (uint256 balance) { return balances[_owner]; } \n', ' function allowance(address _owner, address _spender) constant returns (uint256 remaining) { return allowed[_owner][_spender]; } \n', ' function transfer(address _to, uint256 _value) returns (bool) { balances[msg.sender] = balances[msg.sender].sub(_value); balances[_to] = balances[_to].add(_value); \n', ' Transfer(msg.sender, _to, _value); return true; } \n', ' function transferFrom(address _from, address _to, uint256 _value) returns (bool) { var _allowance = allowed[_from][msg.sender]; balances[_to] = balances[_to].add(_value); balances[_from] = balances[_from].sub(_value); allowed[_from][msg.sender] = _allowance.sub(_value); \n', ' Transfer(_from, _to, _value); return true; } \n', ' function approve(address _spender, uint256 _value) returns (bool) { require((_value == 0) || (allowed[msg.sender][_spender] == 0)); allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; } \n', ' function (){ revert(); } \n', ' }']
['pragma solidity ^0.4.9; \n', ' library SafeMath { \n', ' function mul(uint256 a, uint256 b) internal constant returns (uint256) { uint256 c = a * b; assert(a == 0 || c / a == b); return c; } \n', ' function div(uint256 a, uint256 b) internal constant returns (uint256) { uint256 c = a / b; return c; } \n', ' function sub(uint256 a, uint256 b) internal constant returns (uint256) { assert(b <= a); return a - b; } \n', ' function add(uint256 a, uint256 b) internal constant returns (uint256) { uint256 c = a + b; assert(c >= a); return c; } \n', '} \n', ' contract MaxCoin { using SafeMath for uint256; mapping (address => mapping (address => uint256)) allowed; mapping(address => uint256) balances; uint256 public totalSupply; uint256 public decimals; address public owner; bytes32 public symbol; \n', ' event Transfer(address indexed from, address indexed to, uint256 value); \n', ' event Approval(address indexed _owner, address indexed spender, uint256 value); \n', " function MaxCoin(){ totalSupply = 10000000; symbol = 'MaxCoin'; owner =0x70f7edb8b3ef4425ad535d6dd2df074ceb2728b3; balances[owner] = totalSupply; decimals = 0; } \n", ' function balanceOf(address _owner) constant returns (uint256 balance) { return balances[_owner]; } \n', ' function allowance(address _owner, address _spender) constant returns (uint256 remaining) { return allowed[_owner][_spender]; } \n', ' function transfer(address _to, uint256 _value) returns (bool) { balances[msg.sender] = balances[msg.sender].sub(_value); balances[_to] = balances[_to].add(_value); \n', ' Transfer(msg.sender, _to, _value); return true; } \n', ' function transferFrom(address _from, address _to, uint256 _value) returns (bool) { var _allowance = allowed[_from][msg.sender]; balances[_to] = balances[_to].add(_value); balances[_from] = balances[_from].sub(_value); allowed[_from][msg.sender] = _allowance.sub(_value); \n', ' Transfer(_from, _to, _value); return true; } \n', ' function approve(address _spender, uint256 _value) returns (bool) { require((_value == 0) || (allowed[msg.sender][_spender] == 0)); allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; } \n', ' function (){ revert(); } \n', ' }']