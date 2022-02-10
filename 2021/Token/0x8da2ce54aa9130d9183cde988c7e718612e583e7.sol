['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-17\n', '*/\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    \n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract fynxtoken is IERC20 {\n', '    \n', '    mapping (address => uint256) public _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '    \n', '    \n', '    uint256 private _totalSupply;\n', '    address private _owner;\n', '    string private _name;\n', '    string private _symbol;\n', '    uint256 private _decimals;\n', '    \n', '    constructor ()  {\n', "        _name = 'fynx token';\n", "        _symbol = 'FYNX';\n", '        _decimals = 18;\n', '        _owner = 0xF0d558920Cd4db271044D0A66a713Ec371e0dc67;\n', '        \n', '        \n', '        _totalSupply =  10000000000  * (10**_decimals);\n', '        \n', '        //transfer total supply to owner\n', '        _balances[_owner] =_totalSupply;\n', '        \n', '        //fire an event on transfer of tokens\n', '        emit Transfer(address(this),_owner, _balances[_owner]);\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    \n', '     function decimals() public view returns (uint256) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '        \n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public  override returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '   \n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', ' \n', '    function approve(address spender, uint256 amount) public  virtual override returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        require(_allowances[sender][msg.sender]>=amount,"In Sufficient allowance");\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender,msg.sender, _allowances[sender][msg.sender]-=amount);\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '        require(sender != recipient,"cannot send money to your Self");\n', '        require(_balances[sender]>=amount,"In Sufficiebt Funds");\n', '        \n', '        _balances[sender] -= amount;\n', '        _balances[recipient] +=amount;\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '     \n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '        require(owner != spender,"cannot send allowances to yourself");\n', '        require(_balances[owner]>=amount,"In Sufficiebt Funds");\n', '    \n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '}']