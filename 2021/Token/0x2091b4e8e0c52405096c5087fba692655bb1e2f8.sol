['// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.5.16;\n', '\n', 'contract Context {\n', '    constructor() internal {}\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', "        require(_owner == _msgSender(), 'Ownable: caller is not the owner');\n", '        _;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address newOwner) internal {\n', "        require(newOwner != address(0), 'Ownable: new owner is the zero address');\n", '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', "        require(c >= a, 'SafeMath: addition overflow');\n", '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        return sub(a, b, 'SafeMath: subtraction overflow');\n", '    }\n', '\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', "        require(c / a == b, 'SafeMath: multiplication overflow');\n", '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        return div(a, b, 'SafeMath: division by zero');\n", '    }\n', '\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        return mod(a, b, 'SafeMath: modulo by zero');\n", '    }\n', '\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '\n', '    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = x < y ? x : y;\n', '    }\n', '\n', '    function sqrt(uint256 y) internal pure returns (uint256 z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint256 x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '}\n', '\n', 'contract ONXSupplyToken is Context, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) public balances;\n', '    mapping(address => mapping(address => uint256)) public allowances;\n', '\n', '    uint256 public totalSupply;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '\tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    constructor() public {\n', "        name = 'ONXSupply Token';\n", "        symbol = 'ONXSUP';\n", '        decimals = 18;\n', '        totalSupply = 0;\n', '    }\n', '\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public virtual returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(\n', '            sender,\n', '            _msgSender(),\n', "            allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')\n", '        );\n', '        return true;\n', '    }\n', '\n', '    function _transfer(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) internal virtual {\n', "        require(sender != address(0), 'ERC20: transfer from the zero address');\n", "        require(recipient != address(0), 'ERC20: transfer to the zero address');\n", '\n', "        balances[sender] = balances[sender].sub(amount, 'ERC20: transfer amount exceeds balance');\n", '        balances[recipient] = balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function mint(address account, uint256 amount) public onlyOwner {\n', "        require(account != address(0), 'ERC20: mint to the zero address');\n", '\n', '        totalSupply = totalSupply.add(amount);\n', '        balances[account] = balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function burn(address account, uint256 amount) public onlyOwner {\n', "        require(account != address(0), 'ERC20: burn from the zero address');\n", '\n', "        balances[account] = balances[account].sub(amount, 'ERC20: burn amount exceeds balance');\n", '        totalSupply = totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 amount\n', '    ) internal {\n', "        require(owner != address(0), 'ERC20: approve from the zero address');\n", "        require(spender != address(0), 'ERC20: approve to the zero address');\n", '\n', '        allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '}']