['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-30\n', '*/\n', '\n', 'pragma solidity ^0.8.4;\n', '\n', 'interface ERC20 {\n', '\n', '    //Methods\n', '\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    //Events\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract Token is ERC20{\n', '\n', '    mapping(address => uint256) private _balances;\n', '    mapping(address => mapping(address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '    uint8 private _decimals;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '\n', '    address payable private _owner;\n', '\n', '\n', '    constructor() {\n', '        _symbol = "LMAO";\n', '        _name = "LMAO TOKEN";\n', '        _decimals = 6;\n', '        _totalSupply = 10000000000000;\n', '        _owner = payable(msg.sender);\n', '        _balances[_owner] = _totalSupply;\n', '    }\n', '\n', '    function name() public view virtual returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view virtual returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view virtual returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view virtual override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view virtual override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '\n', '        uint256 currentAllowance = _allowances[sender][msg.sender];\n', '        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");\n', '        unchecked {\n', '            _approve(sender, msg.sender, currentAllowance - amount);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function _transfer(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        uint256 senderBalance = _balances[sender];\n', '        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");\n', '        unchecked {\n', '            _balances[sender] = senderBalance - amount;\n', '        }\n', '        _balances[recipient] += amount;\n', '\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '\n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 amount\n', '    ) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '}']