['// SPDX-License-Identifier: MIT\n', '\n', 'import "@openzeppelin/contracts/access/Ownable.sol";\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import "@chainlink/contracts/src/v0.7/interfaces/AggregatorV3Interface.sol";\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'contract TokenDistribution is Ownable {\n', '\n', '    address public token;\n', '    address public oracle;\n', '    \n', '    // price format is 8 decimals precision: $1 = 100000000, $0.01 = 1000000\n', '    uint256 public tokenPriceUSD     = 5000000; // 0.05 USD\n', '    uint256 public minLimitUSD   = 50000000000; // 500 USD\n', '    uint256 public maxLimitUSD = 2000000000000; // 20 000 USD\n', '\n', '    uint256 public weiRaised;\n', '    uint256 public notClaimedTokens;\n', '\n', '    uint256 public presaleStartsAt;\n', '    uint256 public presaleEndsAt;\n', '    uint256 public claimStartsAt;\n', '\n', '    mapping(address => bool) public whitelisted;\n', '    mapping(address => uint256) public preBoughtTokens;\n', '    mapping(address => uint256) public contributionInUSD;\n', '\n', '    event Withdraw(address indexed owner, uint256 indexed amount);\n', '    event BuyTokens(address indexed buyer, uint256 indexed tokens, uint256 indexed pricePerToken, uint256 buyingPower);\n', '    event PreBuyTokens(address indexed buyer, uint256 indexed tokens, uint256 indexed pricePerToken, uint256 buyingPower);\n', '    event ClaimedTokens(address indexed buyer, uint256 indexed tokens);\n', '\n', '    constructor(\n', '        address _token, \n', '        address _oracle,\n', '        uint256 _presaleStartsAt,\n', '        uint256 _presaleEndsAt,\n', '        uint256 _claimStartsAt\n', '        ) public {\n', '\n', '        require(_token != address(0));\n', '        require(_oracle != address(0));\n', '        \n', '        require(_presaleStartsAt > block.timestamp, "Presale should start now or in the future");\n', '        require(_presaleStartsAt < _presaleEndsAt, "Presale cannot start after end date");\n', '        require(_presaleEndsAt < _claimStartsAt, "Presale end date cannot be after claim date");\n', '\n', '        token = _token;\n', '        oracle = _oracle;\n', '\n', '        presaleStartsAt = _presaleStartsAt;\n', '        presaleEndsAt = _presaleEndsAt;\n', '        claimStartsAt = _claimStartsAt;\n', '    }\n', '\n', '    modifier isWhitelisted {\n', '        require(whitelisted[msg.sender], "User is not whitelisted");\n', '\n', '        _;\n', '    }\n', '\n', '    modifier isPresale {\n', '        require(block.timestamp >= presaleStartsAt && block.timestamp <= presaleEndsAt, "It\'s not presale period");\n', '\n', '        _;\n', '    }\n', '\n', '    modifier hasTokensToClaim {\n', '        require(preBoughtTokens[msg.sender] > 0, "User has NO tokens");\n', '\n', '        _;\n', '    }\n', '\n', '    modifier claimStart {\n', '        require(block.timestamp >= claimStartsAt, "Claim period not started");\n', '\n', '        _;\n', '    }\n', '\n', '    receive() external payable {\n', '        buyTokens();\n', '    }\n', '\n', '    function claimTokens() public claimStart hasTokensToClaim {\n', '        \n', '        uint256 usersTokens = preBoughtTokens[msg.sender];\n', '        preBoughtTokens[msg.sender] = 0;\n', '\n', '        notClaimedTokens -= usersTokens;\n', '\n', '        IERC20(token).transfer(msg.sender, usersTokens);\n', '        emit ClaimedTokens(msg.sender, usersTokens);\n', '    }\n', '\n', '    function withdraw() external onlyOwner {\n', '\n', '        uint256 amount = address(this).balance;\n', '        address payable ownerPayable = payable(msg.sender);\n', '        ownerPayable.transfer(amount);\n', '\n', '        emit Withdraw(msg.sender, amount);\n', '    }\n', '\n', '    function withdrawTokens() external onlyOwner claimStart {\n', '        uint256 unsoldTokens = IERC20(token).balanceOf(address(this));\n', '\n', '        IERC20(token).transfer(msg.sender, unsoldTokens - notClaimedTokens);\n', '    }\n', '\n', '    function buyTokens() public payable isPresale isWhitelisted {\n', '        \n', '        (uint256 tokens, uint256 pricePerTokenEth) = calculateNumberOfTokens(msg.value);\n', '        require(tokens > 0, "Insufficient funds");\n', '\n', '        uint256 tradeAmountInUSD = (tokens * tokenPriceUSD) / 10 ** 18;\n', '        \n', '        require(tradeAmountInUSD >= minLimitUSD, "Send amount is below min limit");\n', '        require(tradeAmountInUSD + contributionInUSD[msg.sender] <= maxLimitUSD, "Send amount is above max limit");\n', '\n', '        preBoughtTokens[msg.sender] += tokens;\n', '        contributionInUSD[msg.sender] += tradeAmountInUSD;\n', '        weiRaised += msg.value;\n', '        notClaimedTokens += tokens;\n', '\n', '        emit PreBuyTokens(msg.sender, tokens, pricePerTokenEth, msg.value);\n', '    }\n', '\n', '    function calculateNumberOfTokens(uint256 _wei) public view returns(uint256, uint256){\n', '\n', '        uint256 pricePerTokenETH = getPriceInEthPerToken();\n', '        uint256 numberOfTokens = divide(_wei, pricePerTokenETH, 18);\n', '        if (numberOfTokens == 0) {\n', '            return(0,0);\n', '        }\n', '\n', '        return (numberOfTokens, pricePerTokenETH);\n', '    }\n', '\n', '    function getPriceInEthPerToken() public view returns(uint256) {\n', '        int oraclePriceTemp = getLatestPriceETHUSD();\n', '        require(oraclePriceTemp > 0, "Invalid price");\n', '\n', '        uint256 oraclePriceETHUSD = uint256(oraclePriceTemp);\n', '\n', '        // returned value format is in 18 decimals precision\n', '        return divide(tokenPriceUSD, oraclePriceETHUSD, 18);\n', '    }\n', '\n', '    function getLatestPriceETHUSD() public view returns (int) {\n', '        (\n', '            uint80 roundID, \n', '            int price,\n', '            uint startedAt,\n', '            uint timeStamp,\n', '            uint80 answeredInRound\n', '        ) = AggregatorV3Interface(oracle).latestRoundData();\n', '\n', '        return price;\n', '    }\n', '\n', '    function getDecimalOracle() public view returns (uint8) {\n', '        (\n', '            uint8 decimals\n', '        ) = AggregatorV3Interface(oracle).decimals();\n', '\n', '        return decimals;\n', '    }\n', '\n', '    function divide(uint a, uint b, uint precision) private pure returns ( uint) {\n', '        return (a * (10**precision)) / b;\n', '    }\n', '\n', '    function whitelist(address[] memory addresses) public onlyOwner {\n', '        for (uint256 i = 0; i < addresses.length; i++) {\n', '            whitelisted[addresses[i]] = true;\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../utils/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.7.0;\n', '\n', 'interface AggregatorV3Interface {\n', '\n', '  function decimals() external view returns (uint8);\n', '  function description() external view returns (string memory);\n', '  function version() external view returns (uint256);\n', '\n', '  // getRoundData and latestRoundData should both raise "No data present"\n', '  // if they do not have data to report, instead of returning unset values\n', '  // which could be misinterpreted as actual reported values.\n', '  function getRoundData(uint80 _roundId)\n', '    external\n', '    view\n', '    returns (\n', '      uint80 roundId,\n', '      int256 answer,\n', '      uint256 startedAt,\n', '      uint256 updatedAt,\n', '      uint80 answeredInRound\n', '    );\n', '  function latestRoundData()\n', '    external\n', '    view\n', '    returns (\n', '      uint80 roundId,\n', '      int256 answer,\n', '      uint256 startedAt,\n', '      uint256 updatedAt,\n', '      uint80 answeredInRound\n', '    );\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']