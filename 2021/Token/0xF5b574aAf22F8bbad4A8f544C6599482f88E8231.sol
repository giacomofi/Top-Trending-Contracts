['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-11\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.8.0;\n', '\n', '/*\n', 'INTERFACE ERC20\n', '*/\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    \n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    \n', '    event TransferFrom(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * Context\n', '*/\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this;\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '//SAFE MATH\n', 'library SafeMath {\n', '   \n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        unchecked {\n', '            uint256 c = a + b;\n', '            if (c < a) return (false, 0);\n', '            return (true, c);\n', '        }\n', '    }\n', '\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        unchecked {\n', '            if (b > a) return (false, 0);\n', '            return (true, a - b);\n', '        }\n', '    }\n', '\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        unchecked {\n', '            if (a == 0) return (true, 0);\n', '            uint256 c = a * b;\n', '            if (c / a != b) return (false, 0);\n', '            return (true, c);\n', '        }\n', '    }\n', '\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        unchecked {\n', '            if (b == 0) return (false, 0);\n', '            return (true, a / b);\n', '        }\n', '    }\n', '\n', '\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        unchecked {\n', '            if (b == 0) return (false, 0);\n', '            return (true, a % b);\n', '        }\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a + b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a - b;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a * b;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a % b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        unchecked {\n', '            require(b <= a, errorMessage);\n', '            return a - b;\n', '        }\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        unchecked {\n', '            require(b > 0, errorMessage);\n', '            return a / b;\n', '        }\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        unchecked {\n', '            require(b > 0, errorMessage);\n', '            return a % b;\n', '        }\n', '    }\n', '}\n', '\n', '//OWNABLE\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'abstract contract Pausable is Ownable {\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '    \n', '    bool private _paused;\n', '\n', '    constructor () {\n', '        _paused = false;\n', '    }\n', '\n', '    function paused() public view virtual returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused(), "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused(), "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    function pause() public virtual whenNotPaused onlyOwner {\n', '        _paused = true;\n', '        emit Paused(_msgSender());\n', '    }\n', '\n', '    function unpause() public virtual whenPaused onlyOwner {\n', '        _paused = false;\n', '        emit Unpaused(_msgSender());\n', '    }\n', '}\n', '\n', '/**\n', ' * TOKEN ERC20\n', '*/\n', 'contract ERC20 is Context, IERC20, Pausable {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '    \n', '    event Redeem(address owner,  uint amount);\n', '\n', '    constructor () {\n', '        _name = "CRDT USD";\n', '        _symbol = "SCRDT";\n', '        _totalSupply = 0;\n', '    }\n', '    \n', '    function pay() public payable {}\n', '\n', '    function name() public view virtual returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view virtual returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view virtual returns (uint8) {\n', '        return 18;\n', '    }\n', '\n', '    function totalSupply() public view virtual override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view virtual override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '    \n', '    function transfer(address recipient, uint256 amount) public whenNotPaused virtual override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    \n', '\n', '    function approve(address spender, uint256 amount) public whenNotPaused virtual override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address sender, address recipient, uint256 amount) public whenNotPaused virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '\n', '        uint256 currentAllowance = _allowances[sender][_msgSender()];\n', '        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");\n', '        \n', '        currentAllowance = currentAllowance.sub(amount);\n', '        \n', '        _approve(sender, _msgSender(), currentAllowance);\n', '\n', '        emit TransferFrom(sender, recipient, amount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n', '        return true;\n', '    }\n', '    \n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused virtual returns (bool) {\n', '        uint256 currentAllowance = _allowances[_msgSender()][spender];\n', '        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");\n', '        currentAllowance = currentAllowance.sub(subtractedValue);\n', '        _approve(_msgSender(), spender, currentAllowance);\n', '\n', '        return true;\n', '    }\n', '    \n', '    function mint(uint amount, address recepient) external onlyOwner whenNotPaused returns(bool) {\n', '        require(amount > 0, "ERC20: Amount must be greater than 0");\n', '        _mint(recepient, amount);\n', '        return true;\n', '    }\n', '    \n', '    function redeem(uint256 amount) external onlyOwner whenNotPaused returns (bool) {\n', '        require(_totalSupply >= amount, "ERC20: Totalsupply cannot be greater than the amount");\n', '        require(_balances[_msgSender()] >= amount, "ERC20: The amount is greater than the balance");\n', '        \n', '        _totalSupply = _totalSupply.sub(amount);\n', '        \n', '        _balances[_msgSender()] = _balances[_msgSender()].sub(amount);\n', '\n', '        emit Redeem(_msgSender(), amount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _beforeTokenTransfer(sender, recipient, amount);\n', '\n', '        uint256 senderBalance = _balances[sender];\n', '        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");\n', '        \n', '        senderBalance = senderBalance.sub(amount);\n', '        _balances[sender] = senderBalance;\n', '        \n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        \n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    \n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _beforeTokenTransfer(address(0), account, amount);\n', '        \n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '    \n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }\n', '}']