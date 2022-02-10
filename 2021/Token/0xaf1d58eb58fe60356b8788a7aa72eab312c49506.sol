['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-05\n', '*/\n', '\n', '// File: contracts\\open-zeppelin-contracts\\token\\ERC20\\IERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    \n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    \n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    \n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    \n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    \n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts\\open-zeppelin-contracts\\math\\SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'library SafeMath {\n', '   \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    \n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts\\open-zeppelin-contracts\\token\\ERC20\\ERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    \n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '   \n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    \n', '    function transfer(address recipient, uint256 amount) public returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    \n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    \n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    \n', '    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));\n', '        return true;\n', '    }\n', '\n', '    \n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    \n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '\n', '    \n', '    function _transfer(address sender, address recipient, uint256 amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount);\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '   \n', '    function _mint(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '     \n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    \n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '    \n', '    function _burnFrom(address account, uint256 amount) internal {\n', '        _burn(account, amount);\n', '        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));\n', '    }\n', '}\n', '\n', '// File: contracts\\ERC20\\ElonDeFiToken.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', 'contract ElonDeFiToken is ERC20 {\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    \n', '    constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {\n', '      _name = name;\n', '      _symbol = symbol;\n', '      _decimals = decimals;\n', '\n', '      // set tokenOwnerAddress as owner of all tokens\n', '      _mint(tokenOwnerAddress, totalSupply);\n', '\n', '      // pay the service fee for contract deployment\n', '      feeReceiver.transfer(msg.value);\n', '    }\n', '\n', '    \n', '    function burn(uint256 value) public {\n', '      _burn(msg.sender, value);\n', '    }\n', '\n', '    // optional functions from ERC20 stardard\n', '\n', '   \n', '    function name() public view returns (string memory) {\n', '      return _name;\n', '    }\n', '\n', '    \n', '    function symbol() public view returns (string memory) {\n', '      return _symbol;\n', '    }\n', '\n', '    \n', '    function decimals() public view returns (uint8) {\n', '      return _decimals;\n', '    }\n', '}']