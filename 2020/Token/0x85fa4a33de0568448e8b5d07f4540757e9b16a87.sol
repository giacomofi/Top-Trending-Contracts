['/**\n', ' *Submitted for verification at Etherscan.io on 2020-07-15\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2020-05-24\n', '*/\n', '\n', 'pragma solidity ^0.4.21;\n', '\n', 'interface ERC20 {\n', '   function balanceOf(address who) public view returns (uint256);\n', '   function transfer(address to, uint256 value) public returns (bool);\n', '   function allowance(address owner, address spender) public view returns (uint256);\n', '   function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '   function approve(address spender, uint256 value) public returns (bool);\n', '   event Transfer(address indexed from, address indexed to, uint256 value);\n', '   event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'library SafeMath {\n', '   function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '       if (a == 0) {\n', '           return 0;\n', '       }\n', '       uint256 c = a * b;\n', '       assert(c / a == b);\n', '       return c;\n', '   }\n', '\n', '   function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '       // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '       uint256 c = a / b;\n', "       // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '       return c;\n', '   }\n', '\n', '   function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '       assert(b <= a);\n', '       return a - b;\n', '   }\n', '\n', '   function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '       uint256 c = a + b;\n', '       assert(c >= a);\n', '       return c;\n', '   }\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '   using SafeMath for uint;\n', '\n', '   string  internal _name;\n', '   string  internal _symbol;\n', '   uint8   internal _decimals;\n', '   uint256 internal _totalSupply;\n', '\n', '   mapping (address => uint256) internal balances;\n', '   mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '   function StandardToken() public {\n', '       _name = "CommaOpenChat";                                  // Set the name for display purposes\n', '       _decimals = 18;                                      // Amount of decimals for display purposes\n', '       _symbol = "COC";                                     // Set the symbol for display purposes\n', '       _totalSupply = 5000000000000000000000000000;         // Update total supply (100000 for example)\n', '       balances[msg.sender] = 5000000000000000000000000000;               // Give the creator all initial tokens (100000 for example)       \n', '   }\n', '\n', '   function name()\n', '   public\n', '   view\n', '   returns (string) {\n', '       return _name;\n', '   }\n', '\n', '   function symbol()\n', '   public\n', '   view\n', '   returns (string) {\n', '       return _symbol;\n', '   }\n', '\n', '   function decimals()\n', '   public\n', '   view\n', '   returns (uint8) {\n', '       return _decimals;\n', '   }\n', '\n', '   function totalSupply()\n', '   public\n', '   view\n', '   returns (uint256) {\n', '       return _totalSupply;\n', '   }\n', '\n', '   function transfer(address _to, uint256 _value) public returns (bool) {\n', '       require(_to != address(0));\n', '       require(_value <= balances[msg.sender]);\n', '       balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);\n', '       balances[_to] = SafeMath.add(balances[_to], _value);\n', '       Transfer(msg.sender, _to, _value);\n', '       return true;\n', '   }\n', '\n', '   function isContract(address _addr) private returns (bool is_contract) {\n', '       uint length;\n', '       assembly {\n', '       //retrieve the size of the code on target address, this needs assembly\n', '           length := extcodesize(_addr)\n', '       }\n', '       return (length>0);\n', '   }\n', '\n', '   function balanceOf(address _owner) public view returns (uint256 balance) {\n', '       return balances[_owner];\n', '   }\n', '\n', '   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '       require(_to != address(0));\n', '       require(_value <= balances[_from]);\n', '       require(_value <= allowed[_from][msg.sender]);\n', '\n', '       balances[_from] = SafeMath.sub(balances[_from], _value);\n', '       balances[_to] = SafeMath.add(balances[_to], _value);\n', '       allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);\n', '       Transfer(_from, _to, _value);\n', '       return true;\n', '   }\n', '\n', '   function approve(address _spender, uint256 _value) public returns (bool) {\n', '       allowed[msg.sender][_spender] = _value;\n', '       Approval(msg.sender, _spender, _value);\n', '       return true;\n', '   }\n', '\n', '   function allowance(address _owner, address _spender) public view returns (uint256) {\n', '       return allowed[_owner][_spender];\n', '   }\n', '\n', '   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '       allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);\n', '       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '       return true;\n', '   }\n', '\n', '   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '       uint oldValue = allowed[msg.sender][_spender];\n', '       if (_subtractedValue > oldValue) {\n', '           allowed[msg.sender][_spender] = 0;\n', '       } else {\n', '           allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);\n', '       }\n', '       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '       return true;\n', '   }\n', '}']