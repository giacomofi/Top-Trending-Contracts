['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-05\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.8.4;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender,address recipient,uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '}\n', '\n', 'contract ERC20 is IERC20 {\n', '\n', '    address admin;\n', '\n', '    mapping(address => uint256) private _balances;\n', '\n', '    mapping(address => mapping(address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 _decimal;\n', '\n', '    constructor(string memory name_, string memory symbol_, uint8 decimal_) {\n', '        _name = name_;\n', '        _symbol = symbol_;\n', '        _decimal = decimal_;\n', '    }\n', '\n', '    function name() public view virtual override returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view virtual override returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view virtual override returns (uint8) {\n', '        return _decimal;\n', '    }\n', '\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        return msg.data;\n', '    }\n', '\n', '    function totalSupply() public view virtual override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    function balanceOf(address account) public view virtual override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '\n', '        uint256 currentAllowance = _allowances[sender][_msgSender()];\n', '        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");\n', '        unchecked {\n', '            _approve(sender, _msgSender(), currentAllowance - amount);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        uint256 currentAllowance = _allowances[_msgSender()][spender];\n', '        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");\n', '        unchecked {\n', '            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n', '        }\n', '\n', '        return true;\n', '    }\n', '    function _transfer(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _beforeTokenTransfer(sender, recipient, amount);\n', '\n', '        uint256 senderBalance = _balances[sender];\n', '        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");\n', '        unchecked {\n', '            _balances[sender] = senderBalance - amount;\n', '        }\n', '        _balances[recipient] += amount;\n', '\n', '        emit Transfer(sender, recipient, amount);\n', '\n', '        _afterTokenTransfer(sender, recipient, amount);\n', '    }\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _beforeTokenTransfer(address(0), account, amount);\n', '\n', '        _totalSupply += amount;\n', '        _balances[account] += amount;\n', '        emit Transfer(address(0), account, amount);\n', '\n', '        _afterTokenTransfer(address(0), account, amount);\n', '    }\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _beforeTokenTransfer(account, address(0), amount);\n', '\n', '        uint256 accountBalance = _balances[account];\n', '        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");\n', '        unchecked {\n', '            _balances[account] = accountBalance - amount;\n', '        }\n', '        _totalSupply -= amount;\n', '\n', '        emit Transfer(account, address(0), amount);\n', '\n', '        _afterTokenTransfer(account, address(0), amount);\n', '    }\n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 amount\n', '    ) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '    function _beforeTokenTransfer(\n', '        address from,\n', '        address to,\n', '        uint256 amount\n', '    ) internal virtual {}\n', '    function _afterTokenTransfer(\n', '        address from,\n', '        address to,\n', '        uint256 amount\n', '    ) internal virtual {}\n', '\n', '    function _changeAdmin(address _newaddr) internal onlyAdmin {\n', '        admin = _newaddr;\n', '    }\n', '    modifier onlyAdmin {\n', '        require( msg.sender == admin, " Only Admin");\n', '        _;\n', '    }\n', '\n', '}\n', '\n', 'contract FUDX is ERC20 {\n', '\n', '    constructor () ERC20("FUDX_Token", "FUDX", 2) {\n', '        admin = msg.sender;\n', '        _mint(admin, 1900000000);\n', '    }\n', '\n', '    function newOwner(address _newOwner) public onlyAdmin {\n', '        _changeAdmin(_newOwner);\n', '    }\n', '\n', '    function mint(address _account, uint256 _qty) public onlyAdmin {\n', '        _mint(_account, _qty);\n', '    }\n', '\n', '    function burn(address _account, uint256 _qty) public onlyAdmin {\n', '        _burn(_account, _qty);\n', '    }\n', '\n', '    function bulkTransfer(address[] memory _recipient, uint256[] memory _amount) public {\n', '        require(_recipient.length == _amount.length, "Different array length");\n', '        for(uint i=0;i<_recipient.length;i++) {\n', '            transfer(_recipient[i], _amount[i]);\n', '        }\n', '    }\n', '    \n', '}']