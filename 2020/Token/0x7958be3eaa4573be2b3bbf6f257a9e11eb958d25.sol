['pragma solidity 0.5.12;\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint c = a / b;\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint;\n', '\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '\n', '    function safeTransfer(IERC20 token, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(isContract(address(token)), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    function add(Role storage role, address account) internal {\n', '        require(!has(role, account), "Roles: account already has role");\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    function remove(Role storage role, address account) internal {\n', '        require(has(role, account), "Roles: account does not have role");\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0), "Roles: account is the zero address");\n', '        return role.bearer[account];\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address internal _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor(address initialOwner) internal {\n', '        require(initialOwner != address(0), "Ownable: initial owner is the zero address");\n', '        _owner = initialOwner;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_isOwner(msg.sender), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function _isOwner(address account) internal view returns (bool) {\n', '        return account == _owner;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title MinterRole\n', ' */\n', 'contract MinterRole is Ownable {\n', '    using Roles for Roles.Role;\n', '\n', '    event MinterAdded(address indexed account);\n', '    event MinterRemoved(address indexed account);\n', '\n', '    Roles.Role private _minters;\n', '\n', '    modifier onlyMinter() {\n', '        require(isMinter(msg.sender), "Caller has no permission");\n', '        _;\n', '    }\n', '\n', '    function isMinter(address account) public view returns (bool) {\n', '        return(_minters.has(account) || _isOwner(account));\n', '    }\n', '\n', '    function addMinter(address account) public onlyOwner {\n', '        _minters.add(account);\n', '        emit MinterAdded(account);\n', '    }\n', '\n', '    function removeMinter(address account) public onlyOwner {\n', '        _minters.remove(account);\n', '        emit MinterRemoved(account);\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address recipient, uint amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '    function approve(address spender, uint amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract Context {\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', 'contract ERC20 is Context, IERC20 {\n', '    using SafeMath for uint;\n', '\n', '    mapping (address => uint) private _balances;\n', '\n', '    mapping (address => mapping (address => uint)) private _allowances;\n', '\n', '    uint private _totalSupply;\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    function balanceOf(address account) public view returns (uint) {\n', '        return _balances[account];\n', '    }\n', '    function transfer(address recipient, uint amount) public returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '    function allowance(address owner, address spender) public view returns (uint) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    function approve(address spender, uint amount) public returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address sender, address recipient, uint amount) public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '    function increaseAllowance(address spender, uint addedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '    function _transfer(address sender, address recipient, uint amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    function _mint(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '    function _burn(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '    function _burnFrom(address account, uint256 amount) internal {\n', '        _burn(account, amount);\n', '        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));\n', '    }\n', '    function _approve(address owner, address spender, uint amount) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Extension of `ERC20` that allows token holders to destroy both their own\n', ' * tokens and those that they have an allowance for, in a way that can be\n', ' * recognized off-chain (via event analysis).\n', ' */\n', 'contract ERC20Burnable is ERC20 {\n', '    /**\n', "     * @dev Destroys `amount` tokens from msg.sender's balance.\n", '     */\n', '    function burn(uint256 amount) public {\n', '        _burn(msg.sender, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted\n', "     * from the caller's allowance.\n", '     */\n', '    function burnFrom(address account, uint256 amount) public {\n', '        _burnFrom(account, amount);\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},\n', ' * which have permission to mint (create) new tokens as they see fit.\n', ' */\n', 'contract ERC20Mintable is ERC20Burnable, MinterRole {\n', '\n', '    // if additional minting of tokens is impossible\n', '    bool public mintingFinished;\n', '\n', '    // prevent minting of tokens when it is finished.\n', '    // prevent total supply to exceed the limit of emission.\n', '    modifier canMint(uint256 amount) {\n', '        require(amount > 0, "Minting zero amount");\n', '        require(!mintingFinished, "Minting is finished");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Stop any additional minting of tokens forever.\n', '     * Available only to the owner.\n', '     */\n', '    function finishMinting() external onlyOwner {\n', '        mintingFinished = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Minting of new tokens.\n', '     * @param to The address to mint to.\n', '     * @param value The amount to be minted.\n', '     */\n', '    function mint(address to, uint256 value) public onlyMinter canMint(value) returns (bool) {\n', '        _mint(to, value);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ApproveAndCall Interface.\n', ' * @dev ApproveAndCall system allows to communicate with smart-contracts.\n', ' */\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 amount, address token, bytes calldata extraData) external;\n', '}\n', '\n', '/**\n', ' * @title The main project contract.\n', ' */\n', 'contract SXTToken is ERC20Mintable, ERC20Detailed {\n', '    using SafeERC20 for IERC20;\n', '    using SafeMath for uint256;\n', '\n', '    // registered contracts (to prevent loss of token via transfer function)\n', '    mapping (address => bool) private _contracts;\n', '\n', '    constructor(address initialOwner, address recipient) public ERC20Detailed("Sixteen", "SXT", 4) Ownable(initialOwner) {\n', '        // creating of inital supply\n', '        uint256 INITIAL_SUPPLY = 9999999e4;\n', '        _mint(recipient, INITIAL_SUPPLY);\n', '    }\n', '\n', '    /**\n', '     * @dev modified transfer function that allows to safely send tokens to smart-contract.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '\n', '        if (_contracts[to]) {\n', '            approveAndCall(to, value, new bytes(0));\n', '        } else {\n', '            super.transfer(to, value);\n', '        }\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '    /**\n', '    * @dev Allows to send tokens (via Approve and TransferFrom) to other smart-contract.\n', '    * @param spender Address of smart contracts to work with.\n', '    * @param amount Amount of tokens to send.\n', '    * @param extraData Any extra data.\n', '    */\n', '    function approveAndCall(address spender, uint256 amount, bytes memory extraData) public returns (bool) {\n', '        require(approve(spender, amount));\n', '\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, amount, address(this), extraData);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows to register other smart-contracts (to prevent loss of tokens via transfer function).\n', '     * @param account Address of smart contracts to work with.\n', '     */\n', '    function registerContract(address account) external onlyOwner {\n', '        require(_isContract(account), "Token: account is not a smart contract");\n', '        _contracts[account] = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows to unregister registered smart-contracts.\n', '     * @param account Address of smart contracts to work with.\n', '     */\n', '    function unregisterContract(address account) external onlyOwner {\n', '        require(isRegistered(account), "Token: account is not registered yet");\n', '        _contracts[account] = false;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows to any owner of the contract withdraw needed ERC20 token from this contract (for example promo or bounties).\n', '    * @param ERC20Token Address of ERC20 token.\n', '    * @param recipient Account to receive tokens.\n', '    */\n', '    function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {\n', '\n', '        uint256 amount = IERC20(ERC20Token).balanceOf(address(this));\n', '        IERC20(ERC20Token).safeTransfer(recipient, amount);\n', '\n', '    }\n', '\n', '    /**\n', '     * @return true if the address is registered as contract\n', '     * @param account Address to be checked.\n', '     */\n', '    function isRegistered(address account) public view returns (bool) {\n', '        return _contracts[account];\n', '    }\n', '\n', '    /**\n', '     * @return true if `account` is a contract.\n', '     * @param account Address to be checked.\n', '     */\n', '    function _isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '}']