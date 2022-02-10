['pragma solidity ^0.4.18;\n', '\n', '// Math operations with safety checks that throw on error\n', 'library SafeMath {\n', '\t\n', '\tfunction mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tif (a == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\tuint256 c = a * b;\n', '\t\tassert(c / a == b);\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tassert(b > 0);\n', '\t\tuint256 c = a / b;\n', '\t\tassert(a == b * c + a % b);\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tassert(b <= a);\n', '\t\treturn a - b;\n', '\t}\n', '\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a + b;\n', '\t\tassert(c >= a);\n', '\t\treturn c;\n', '\t}\n', '\t\n', '}\n', '\n', '// Simpler version of ERC20 interface\n', 'contract ERC20Basic {\n', '\t\n', '\tuint256 public totalSupply;\n', '\tfunction balanceOf(address who) public constant returns (uint256);\n', '\tfunction transfer(address to, uint256 value) public returns (bool);\n', '\tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '\t\n', '}\n', '\n', '// Basic version of StandardToken, with no allowances.\n', 'contract BasicToken is ERC20Basic {\n', '\t\n', '\tusing SafeMath for uint256;\n', '\tmapping(address => uint256) balances;\n', '\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool) {\n', '\t\trequire(_to != address(0));\n', '\t\trequire(_value <= balances[msg.sender]);\n', '\n', '\t\t// SafeMath.sub will throw if there is not enough balance.\n', '\t\tbalances[msg.sender] = balances[msg.sender].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\tTransfer(msg.sender, _to, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '\t//Gets the balance of the specified address.\n', '\tfunction balanceOf(address _owner) public view returns (uint256 balance) {\n', '\t\treturn balances[_owner];\n', '\t}\n', '\n', '}\n', '\n', '//ERC20 interface\n', '// see https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20 is ERC20Basic {\n', '\t\n', '\tfunction allowance(address owner, address spender) public view returns (uint256);\n', '\tfunction transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\tfunction approve(address spender, uint256 value) public returns (bool);\n', '\tevent Approval(address indexed owner, address indexed spender, uint256 value);\n', '\t\n', '}\n', '\n', '// Standard ERC20 token\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '\tmapping (address => mapping (address => uint256)) allowed;\n', '\n', '\t// Transfer tokens from one address to another\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '\t\t\n', '\t\tvar _allowance = allowed[_from][msg.sender];\n', '\t\trequire (_value <= _allowance);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\tallowed[_from][msg.sender] = _allowance.sub(_value);\n', '\t\tTransfer(_from, _to, _value);\n', '\t\treturn true;\n', '\n', '\t}\n', '\n', '\t//Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '\tfunction approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '\t\t// To change the approve amount you first have to reduce the addresses`\n', '\t\t// allowance to zero by calling `approve(_spender, 0)` if it is not\n', '\t\t// already 0 to mitigate the race condition described here:\n', '\t\t// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\t\trequire((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\tApproval(msg.sender, _spender, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '\t//Function to check the amount of tokens that an owner allowed to a spender.\n', '\tfunction allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '\t\treturn allowed[_owner][_spender];\n', '\t}\n', '\t\n', '}\n', '\n', '// The Ownable contract has an owner address, and provides basic authorization control\n', '// functions, this simplifies the implementation of "user permissions".\n', 'contract Ownable {\n', '\t\n', '\taddress public owner;\n', '\n', '\t// The Ownable constructor sets the original `owner` of the contract to the sender account.\n', '\tfunction Ownable() public {\n', '\t\towner = msg.sender;\n', '\t}\n', '\n', '\t// Throws if called by any account other than the owner.\n', '\tmodifier onlyOwner() {\n', '\t\trequire(msg.sender == owner);\n', '\t\t_;\n', '\t}\n', '\n', '\t// Allows the current owner to transfer control of the contract to a newOwner.\n', '\tfunction transferOwnership(address newOwner) public onlyOwner {\n', '\t\tif (newOwner != address(0)) {\n', '\t\t\towner = newOwner;\n', '\t\t}\n', '\t}\n', '\n', '}\n', '\n', '// Base contract which allows children to implement an emergency stop mechanism.\n', 'contract Pausable is Ownable {\n', '\t\n', '\tevent Pause();\n', '\tevent Unpause();\n', '\n', '\tbool public paused = false;\n', '\n', '\tmodifier whenNotPaused() {\n', '\t\trequire(!paused);\n', '\t\t_;\n', '\t}\n', '\n', '\tmodifier whenPaused {\n', '\t\trequire(paused);\n', '\t\t_;\n', '\t}\n', '\n', '\tfunction pause() public onlyOwner whenNotPaused returns (bool) {\n', '\t\tpaused = true;\n', '\t\tPause();\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction unpause() public onlyOwner whenPaused returns (bool) {\n', '\t\tpaused = false;\n', '\t\tUnpause();\n', '\t\treturn true;\n', '\t}\n', '\t\n', '}\n', '\n', '// Evolution+ Token\n', 'contract EVPToken is StandardToken, Pausable {\n', '\t\n', '\tuint256 public totalSupply = 22000000 * 1 ether;\n', '\tstring public name = "Evolution+ Token"; \n', '    uint8 public decimals = 18; \n', '    string public symbol = "EVP";\n', '\t\n', '\t// Contract constructor function sets initial token balances\n', '\tfunction EVPToken() public {\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\t\n', '\tfunction transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '\t\treturn super.transfer(_to, _value);\n', '\t}\n', '\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '\t\treturn super.transferFrom(_from, _to, _value);\n', '\t}\n', '\n', '\tfunction approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '\t\treturn super.approve(_spender, _value);\n', '\t}\n', '\n', '}']