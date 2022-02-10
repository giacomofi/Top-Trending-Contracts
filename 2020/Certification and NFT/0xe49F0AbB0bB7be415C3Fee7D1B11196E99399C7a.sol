['// File @openzeppelin/contracts/GSN/Context.sol@v3.1.0\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '\n', '// File @openzeppelin/contracts/access/Ownable.sol@v3.1.0\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.1.0\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '// File contracts/Vesting.sol\n', '\n', '//SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', '\n', '// Vesting provides the main functionality for the vesting approach taken\n', '// The goal is to enable releasing funds from the timelocks after the exchange listing has happened.\n', '// To keep things simple the contract is Ownable, and the owner (a multisig wallet) is able to indicate that\n', '// the exchange listing has happened. All release dates are defined in days relative to the listing date.\n', '\n', '// All release schedules are set up during minting, HOWEVER, ERC20 balances will be transferred from the initial\n', '// multisig wallets to the Vesting contracts after minting the ERC20.\n', '// Caveat: The release schedules (timelocks) do need a sufficient balance and will otherwise fail. We decided not\n', "// to write any guards for this situation since it's a 1-time only event and it is easy to remedy (send more RAMP).\n", '\n', '// It will be the responsibility of the RAMP team to fund the Vesting contracts as soon as possible, and with\n', '// the amounts necessary.\n', '// It will also be the responsibility of the RAMP team to call the "setListingTime" function at the appropriate time.\n', '\n', 'abstract contract Vesting is Ownable {\n', '\n', '    // Every timelock has this structure\n', '    struct Timelock {\n', '        address beneficiary;\n', '        uint256 balance;\n', '        uint256 releaseTimeOffset;\n', '    }\n', '\n', '    // The timelocks, publicly queryable\n', '    Timelock[] public timelocks;\n', '\n', '    // The time of exchange listing, as submitted by the Owner. Starts as 0.\n', '    uint256 public listingTime = 0;\n', '\n', '    // The token (RAMP DEFI)\n', '    IERC20 token;\n', '\n', '    // Event fired when tokens are released\n', '    event TimelockRelease(address receiver, uint256 amount, uint256 timelock);\n', '\n', '    // Vesting is initialized with the token contract\n', '    constructor(address tokenContract) public {\n', '        token = IERC20(tokenContract);\n', '    }\n', '\n', '    // Sets up a timelock. Intended to be used during instantiation of an implementing contract\n', '    function setupTimelock(address beneficiary, uint256 amount, uint256 releaseTimeOffset)\n', '    internal\n', '    {\n', '        // Create a variable\n', '        Timelock memory timelock;\n', '\n', '        // Set beneficiary\n', '        timelock.beneficiary = beneficiary;\n', '\n', '        // Set balance\n', '        timelock.balance = amount;\n', '\n', '        // Set the release time offset. This is a uint256 representing seconds after listingTime\n', '        timelock.releaseTimeOffset = releaseTimeOffset;\n', '\n', '        // Add the timelock to the array.\n', '        timelocks.push(timelock);\n', '    }\n', '\n', '    // Lets Owner set the listingTime. Can be done only once.\n', '    function setListingTime()\n', '    public\n', '    onlyOwner\n', '    {\n', '        // We can run this only once since listingTime will be a timestamp after.\n', '        require(listingTime == 0, "Listingtime was already set");\n', '\n', '        // Set the listingtime to the current timestamp.\n', '        listingTime = block.timestamp;\n', '    }\n', '\n', '    // Initiates the process to release tokens in a given timelock.\n', '    // Anyone can call this function, but funds will always be released to the beneficiary that was initially set.\n', '    // If the transfer fails for any reason, the transaction will revert.\n', '    // NOTE: It is the RAMP team responsibility to ensure the tokens are indeed owned by this contract.\n', '    function release(uint256 timelockNumber)\n', '    public\n', '    {\n', '        // Check if listingTime is set, otherwise it is not possible to release funds yet.\n', '        require(listingTime > 0, "Listing time was not set yet");\n', '\n', '        // Retrieve the requested timelock struct\n', '        Timelock storage timelock = timelocks[timelockNumber];\n', '\n', '        // Check if the timelock is ready for release.\n', '        require(listingTime + timelock.releaseTimeOffset <= now, "Timelock can not be released yet.");\n', '\n', '        // Get the amount to transfer\n', '        uint256 amount = timelock.balance;\n', '\n', '        // Set the timelock balance to 0\n', '        timelock.balance = 0;\n', '\n', '        // Transfer the token amount to the beneficiary. If this fails, the transaction will revert.\n', '        require(token.transfer(timelock.beneficiary, amount), "Transfer of amount failed");\n', '\n', '        // Emit an event for this.\n', '        emit TimelockRelease(timelock.beneficiary, amount, timelockNumber);\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '// File contracts/VestingTeam.sol\n', '\n', '//SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', '\n', 'contract VestingTeam is Vesting {\n', '\n', '    constructor(address tokenContract, address beneficiary) Vesting(tokenContract) public {\n', '\n', '        // 1 = Team1-6\n', '        setupTimelock(beneficiary, 26666000e18, 182 days);\n', '\n', '        // 2 = Team2-6\n', '        setupTimelock(beneficiary, 26666000e18, 365 days);\n', '\n', '        // 3 = Team3-6\n', '        setupTimelock(beneficiary, 26666000e18, 547 days);\n', '\n', '        // 4 = Team4-6\n', '        setupTimelock(beneficiary, 26666000e18, 730 days);\n', '\n', '        // 5 = Team5-6\n', '        setupTimelock(beneficiary, 26666000e18, 912 days);\n', '\n', '        // 6 = Team6-6\n', '        setupTimelock(beneficiary, 26670000e18, 1095 days);\n', '\n', '        // Make the beneficiary (Team multisig) owner of this contract\n', '        transferOwnership(beneficiary);\n', '    }\n', '\n', '}']