['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-11\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.12;\n', '\n', 'interface IERC20Token {\n', '    function totalSupply() external view returns (uint256);\n', '    function decimals() external view returns (uint8);\n', '    function symbol() external view returns (string memory);\n', '    function name() external view returns (string memory);\n', '    function getOwner() external view returns (address);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address _owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\tfunction mintTo(address to, uint256 amount)  external returns (bool);\n', '\tfunction burn(address account, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', "        require(c >= a, 'SafeMath: addition overflow');\n", '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        return sub(a, b, 'SafeMath: subtraction overflow');\n", '    }\n', '\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', "        require(c / a == b, 'SafeMath: multiplication overflow');\n", '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        return div(a, b, 'SafeMath: division by zero');\n", '    }\n', '\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        return mod(a, b, 'SafeMath: modulo by zero');\n", '    }\n', '\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '\n', '    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = x < y ? x : y;\n', '    }\n', '\n', '    function sqrt(uint256 y) internal pure returns (uint256 z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint256 x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '}\n', '\n', 'contract Context {\n', '    constructor() internal {}\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', "        require(_owner == _msgSender(), 'Ownable: caller is not the owner');\n", '        _;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address newOwner) internal {\n', "        require(newOwner != address(0), 'Ownable: new owner is the zero address');\n", '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', 'contract INRT is Context, IERC20Token, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) private _balances;\n', '    mapping(address => mapping(address => uint256)) private _allowances;\n', '    mapping(address => bool) private keeperMap;\n', '    uint256 private _totalSupply;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '    bool public stopped;\n', '    \n', '    constructor(string memory name, string memory symbol) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = 2;\n', '\t\tstopped = false;\n', '    }\n', '\n', '    modifier ownerOrKeeper(address addr) {\n', '        require((owner() == msg.sender) || isKeeper(addr), "caller is not the owner or keeper");\n', '        _;\n', '    }\n', '\n', '    function setKeeper(address addr) public ownerOrKeeper(msg.sender) {\n', '        keeperMap[addr] = true;\n', '    }\n', '    function removeKeeper(address addr) public ownerOrKeeper(msg.sender) {\n', '        keeperMap[addr] = false;\n', '    }\n', '\n', '    function isKeeper(address addr) public view returns (bool) {\n', '\t\trequire((owner() == msg.sender) || keeperMap[msg.sender], "caller is not the owner or keeper");\n', '        return keeperMap[addr];\n', '    }\n', '\n', '    modifier stoppable {\n', '        require(!stopped);\n', '        _;\n', '    }\n', '    function stop() public ownerOrKeeper(msg.sender) payable {\n', '        stopped = true;\n', '    }\n', '    function start() public ownerOrKeeper(msg.sender) payable {\n', '        stopped = false;\n', '    }\n', '\n', '    function mintTo(address to, uint256 amount) override public returns (bool) {\n', '\t\trequire((owner() == msg.sender) || isKeeper(msg.sender), "caller is not the owner or keeper");\n', '        _mint(to, amount);\n', '        return true;\n', '    }\n', '\n', '    function burn(address account, uint256 amount) override public returns (bool) {\n', '\t\trequire((owner() == msg.sender) || isKeeper(msg.sender), "caller is not the owner or keeper");\n', '        _burn(account, amount);\n', '        return true;\n', '    }\n', '\n', '    function getOwner() external override view returns (address) {\n', '        return owner();\n', '    }\n', '\n', '    function name() public override view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function decimals() public override view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function symbol() public override view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function totalSupply() public override view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public override view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    \n', '    function transfer(address recipient, uint256 amount) public override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    \n', '    function allowance(address owner, address spender) public override view returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    \n', '    function approve(address spender, uint256 amount) public override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    \n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) public override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(\n', '            sender,\n', '            _msgSender(),\n', "            _allowances[sender][_msgSender()].sub(amount, 'transfer amount exceeds allowance')\n", '        );\n', '        return true;\n', '    }\n', '\n', '    \n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    \n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(\n', '            _msgSender(),\n', '            spender,\n', "            _allowances[_msgSender()][spender].sub(subtractedValue, 'decreased allowance below zero')\n", '        );\n', '        return true;\n', '    }\n', '\n', '    \n', '    function mint(uint256 amount) public onlyOwner returns (bool) {\n', '        _mint(_msgSender(), amount);\n', '        return true;\n', '    }\n', '\n', '    function _transfer(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) internal {\n', "        require(sender != address(0), 'transfer from the zero address');\n", "        require(recipient != address(0), 'transfer to the zero address');\n", '\n', "        _balances[sender] = _balances[sender].sub(amount, 'transfer amount exceeds balance');\n", '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    \n', '    function _mint(address account, uint256 amount) internal stoppable {\n', "        require(account != address(0), 'mint to the zero address');\n", '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    \n', '    function _burn(address account, uint256 amount) internal {\n', "        require(account != address(0), 'burn from the zero address');\n", '\n', "        _balances[account] = _balances[account].sub(amount, 'burn amount exceeds balance');\n", '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    \n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 amount\n', '    ) internal {\n', "        require(owner != address(0), 'approve from the zero address');\n", "        require(spender != address(0), 'approve to the zero address');\n", '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    \n', '    function _burnFrom(address account, uint256 amount) internal {\n', '        _burn(account, amount);\n', '        _approve(\n', '            account,\n', '            _msgSender(),\n', "            _allowances[account][_msgSender()].sub(amount, 'burn amount exceeds allowance')\n", '        );\n', '    }\n', '}']