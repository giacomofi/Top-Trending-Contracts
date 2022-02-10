['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-15\n', '*/\n', '\n', 'pragma solidity ^0.8.4;\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    \n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return payable(msg.sender);\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract ASTRRO is IERC20 , Ownable{\n', '    \n', '    mapping (address => uint256) public _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '    \n', ' \n', '    uint256 private _totalSupply;\n', '    address private _owner;\n', '    string private _name;\n', '    string private _symbol;\n', '    uint256 private _decimals;\n', '    \n', '    constructor ()  {\n', "        _name = 'ASTROLAND';\n", "        _symbol = 'ASTRO';\n", '        _decimals = 18;\n', '       _owner = msg.sender;\n', '        \n', '        \n', '        _totalSupply =  50000000  * (10**_decimals);\n', '        \n', '        //transfer total supply to owner\n', '        _balances[_owner] =_totalSupply;\n', '        \n', '        //fire an event on transfer of tokens\n', '        emit Transfer(address(this),_owner, _balances[_owner]);\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    \n', '     function decimals() public view returns (uint256) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '        \n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public  override returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '   \n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', ' \n', '    function approve(address spender, uint256 amount) public  virtual override returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        require(_allowances[sender][msg.sender]>=amount,"In Sufficient allowance");\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender,msg.sender, _allowances[sender][msg.sender]);\n', '        return true;\n', '    }\n', '    \n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '        require(sender != recipient,"cannot send money to your Self");\n', '        require(_balances[sender]>=amount,"In Sufficient Funds");\n', '      \n', '        _balances[sender] -= amount;\n', '        _balances[recipient] +=amount;\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '     \n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '        require(owner != spender,"cannot send allowances to yourself");\n', '        require(_balances[owner]>=amount,"In Sufficient Funds");\n', '    \n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', ' }']