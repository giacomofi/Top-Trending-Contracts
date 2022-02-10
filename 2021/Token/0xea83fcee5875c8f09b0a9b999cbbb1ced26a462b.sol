['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-06\n', '*/\n', '\n', '// File: @openzeppelin/contracts/utils/Context.sol\n', '\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/access/Ownable.sol\n', '\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/WasderSale.sol\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', '\n', '\n', 'contract WasderSale is Ownable {\n', '    address public treasury;\n', '\n', '    // max amount of erc20 a user can pay\n', '    mapping(address => uint256) public buyers_limits;\n', '    address public token;\n', '\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '\n', '    event Purchased (\n', '        address indexed buyer,\n', '        uint256 amount\n', '    );\n', '\n', '    modifier isOpenForDeposits(){\n', '        require(block.timestamp > startTime && block.timestamp < endTime, "Closed for deposits!");\n', '        _;\n', '    }\n', '\n', '    constructor(address _treasury, uint256 _startTime, uint256 _endTime, address _token) public {\n', '        treasury = _treasury;\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        token = _token;\n', '    }\n', '\n', '    function addAllocations(address[] memory _buyer, uint256[] memory _amount) external onlyOwner {\n', '        require(_buyer.length == _amount.length, "Arrays have different lengths!");\n', '\n', '        for (uint i = 0; i < _buyer.length; i++){\n', '            buyers_limits[_buyer[i]] = _amount[i];\n', '        }\n', '    }\n', '\n', '    function setTreasury(address _treasury) external onlyOwner {\n', '        treasury = _treasury;\n', '    }\n', '    function setStartTime(uint256 _startTime) external onlyOwner {\n', '        startTime = _startTime;\n', '    }\n', '    function setEndTime(uint256 _endTime) external onlyOwner {\n', '        endTime = _endTime;\n', '    }\n', '    function setToken(address _token) external onlyOwner {\n', '        token = _token;\n', '    }\n', '\n', '    function adminWithdrawERC20(address _token) external onlyOwner{\n', '        uint256 amount = IERC20(_token).balanceOf(address(this));\n', '        IERC20(_token).transfer(msg.sender, amount);\n', '    }\n', '\n', '    function adminWithdraw() external onlyOwner {\n', '        (bool success, ) = msg.sender.call{ value: address(this).balance }("");\n', '        require(success, "Transfer failed.");\n', '    }\n', '\n', '    function deposit(uint256 _amount) external isOpenForDeposits {\n', '        require(_amount <= buyers_limits[msg.sender], "Limit exceeded");\n', '        buyers_limits[msg.sender] -= _amount;\n', '        IERC20(token).transferFrom(msg.sender, treasury, _amount);\n', '        emit Purchased(msg.sender, _amount);\n', '    }\n', '}']