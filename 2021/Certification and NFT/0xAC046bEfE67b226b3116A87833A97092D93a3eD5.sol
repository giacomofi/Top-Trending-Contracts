['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.6;\n', '\n', 'import "./IERC20Detailed.sol";\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import "@openzeppelin/contracts/utils/Pausable.sol";\n', 'import "@openzeppelin/contracts/math/SafeMath.sol";\n', 'import "./Whitelist.sol";\n', 'import "./libraries/TransferHelper.sol";\n', '\n', 'contract FixedSwap is Pausable, Whitelist {\n', '    using SafeMath for uint256;\n', '    uint256 increment = 0;\n', '\n', '    mapping(uint256 => Purchase) public purchases; /* Purchasers mapping */\n', '    address[] public buyers; /* Current Buyers Addresses */\n', '    uint256[] public purchaseIds; /* All purchaseIds */\n', '    mapping(address => uint256[]) public myPurchases; /* Purchasers mapping */\n', '\n', '    IERC20 public erc20;\n', '    bool public isSaleFunded = false;\n', '    uint public decimals = 0;\n', '    bool public unsoldTokensRedeemed = false;\n', '    uint256 public tradeValue; /* Price in Wei */\n', '    uint256 public startDate; /* Start Date  */\n', '    uint256 public endDate; /* End Date  */\n', '    uint256 public individualMinimumAmount = 0; /* Minimum Amount Per Address */\n', '    uint256 public individualMaximumAmount = 0; /* Maximum Amount Per Address */\n', '    uint256 public minimumRaise = 0; /* Minimum Amount of Tokens that have to be sold */\n', '    uint256 public tokensAllocated = 0; /* Tokens Available for Allocation - Dynamic */\n', '    uint256 public tokensForSale = 0; /* Tokens Available for Sale */\n', '    bool public isTokenSwapAtomic; /* Make token release atomic or not */\n', '    address payable public feeAddress; /* Default Address for Fee Percentage */\n', '    uint256 public feePercentage = 1; /* Default Fee 1% */\n', '    bool private locked;\n', '\n', '    struct Purchase {\n', '        uint256 amount;\n', '        address purchaser;\n', '        uint256 ethAmount;\n', '        uint256 timestamp;\n', '        bool wasFinalized; /* Confirm the tokens were sent already */\n', '        bool reverted; /* Confirm the tokens were sent already */\n', '    }\n', '\n', '    event PurchaseEvent(\n', '        uint256 indexed purchaseId,\n', '        uint256 amount,\n', '        address indexed purchaser,\n', '        uint256 ethAmount,\n', '        uint256 timestamp,\n', '        bool wasFinalized\n', '    );\n', '    event FundEvent(address indexed funder, uint256 amount, address indexed contractAddress, uint256 timestamp);\n', '    event RedeemTokenEvent(\n', '        uint256 indexed purchaseId,\n', '        uint256 amount,\n', '        address indexed purchaser,\n', '        uint256 ethAmount,\n', '        bool wasFinalized,\n', '        bool reverted\n', '    );\n', '\n', '    constructor(\n', '        address _tokenAddress,\n', '        address payable _feeAddress,\n', '        uint256 _tradeValue,\n', '        uint256 _tokensForSale,\n', '        uint256 _startDate,\n', '        uint256 _endDate,\n', '        uint256 _individualMinimumAmount,\n', '        uint256 _individualMaximumAmount,\n', '        bool _isTokenSwapAtomic,\n', '        uint256 _minimumRaise,\n', '        uint256 _feeAmount,\n', '        bool _hasWhitelisting\n', '    ) Whitelist(_hasWhitelisting) {\n', '        /* Confirmations */\n', '        require(block.timestamp < _endDate, "End Date should be further than current date");\n', '        require(block.timestamp < _startDate, "Start Date should be further than current date");\n', '        require(_startDate < _endDate, "End Date higher than Start Date");\n', '        require(_tokensForSale > 0, "Tokens for Sale should be > 0");\n', '        require(_tokensForSale > _individualMinimumAmount, "Tokens for Sale should be > Individual Minimum Amount");\n', '        require(_individualMaximumAmount >= _individualMinimumAmount, "Individual Maximum Amount should be > Individual Minimum Amount");\n', '        require(_minimumRaise <= _tokensForSale, "Minimum Raise should be < Tokens For Sale");\n', '        require(_feeAmount >= feePercentage, "Fee Percentage has to be >= 1");\n', '        require(_feeAmount <= 99, "Fee Percentage has to be < 100");\n', '        require(_feeAddress != address(0), "Fee Address has to be not ZERO");\n', '        require(_tokenAddress != address(0), "Token Address has to be not ZERO");\n', '\n', '        startDate = _startDate;\n', '        endDate = _endDate;\n', '        tokensForSale = _tokensForSale;\n', '        tradeValue = _tradeValue;\n', '\n', '        individualMinimumAmount = _individualMinimumAmount;\n', '        individualMaximumAmount = _individualMaximumAmount;\n', '        isTokenSwapAtomic = _isTokenSwapAtomic;\n', '\n', '        if (!_isTokenSwapAtomic) {\n', '            /* If raise is not atomic swap */\n', '            minimumRaise = _minimumRaise;\n', '        }\n', '\n', '        erc20 = IERC20(_tokenAddress);\n', '        decimals = IERC20Detailed(_tokenAddress).decimals();\n', '        feePercentage = _feeAmount;\n', '        feeAddress = _feeAddress;\n', '    }\n', '\n', '    /**\n', '     * Modifier to make a function callable only when the contract has Atomic Swaps not available.\n', '     */\n', '    modifier isNotAtomicSwap() {\n', '        require(!isTokenSwapAtomic, "Has to be non Atomic swap");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Modifier to make a function callable only when the contract has Atomic Swaps not available.\n', '     */\n', '    modifier isSaleFinalized() {\n', '        require(hasFinalized(), "Has to be finalized");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Modifier to make a function callable only when the swap time is open.\n', '     */\n', '    modifier isSaleOpen() {\n', '        require(isOpen(), "Has to be open");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Modifier to make a function callable only when the contract has Atomic Swaps not available.\n', '     */\n', '    modifier isSalePreStarted() {\n', '        require(isPreStart(), "Has to be pre-started");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Modifier to make a function callable only when the contract has Atomic Swaps not available.\n', '     */\n', '    modifier isFunded() {\n', '        require(isSaleFunded, "Has to be funded");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Modifier for block reentrancy\n', '     */\n', '    modifier blockReentrancy {\n', '        require(!locked, "Reentrancy is blocked");\n', '        locked = true;\n', '        _;\n', '        locked = false;\n', '    } \n', '\n', '    /* Get Functions */\n', '    function isBuyer(uint256 purchase_id) public view returns (bool) {\n', '        return (msg.sender == purchases[purchase_id].purchaser);\n', '    }\n', '\n', '    /* Get Functions */\n', '    function totalRaiseCost() public view returns (uint256) {\n', '        return (cost(tokensForSale));\n', '    }\n', '\n', '    function availableTokens() public view returns (uint256) {\n', '        return erc20.balanceOf(address(this));\n', '    }\n', '\n', '    function tokensLeft() public view returns (uint256) {\n', '        return tokensForSale - tokensAllocated;\n', '    }\n', '\n', '    function hasMinimumRaise() public view returns (bool) {\n', '        return (minimumRaise != 0);\n', '    }\n', '\n', '    /* Verify if minimum raise was not achieved */\n', '    function minimumRaiseNotAchieved() public view returns (bool) {\n', '        require(cost(tokensAllocated) < cost(minimumRaise), "TotalRaise is bigger than minimum raise amount");\n', '        return true;\n', '    }\n', '\n', '    /* Verify if minimum raise was achieved */\n', '    function minimumRaiseAchieved() public view returns (bool) {\n', '        if (hasMinimumRaise()) {\n', '            require(cost(tokensAllocated) >= cost(minimumRaise), "TotalRaise is less than minimum raise amount");\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function hasFinalized() public view returns (bool) {\n', '        return block.timestamp > endDate;\n', '    }\n', '\n', '    function hasStarted() public view returns (bool) {\n', '        return block.timestamp >= startDate;\n', '    }\n', '\n', '    function isPreStart() public view returns (bool) {\n', '        return block.timestamp < startDate;\n', '    }\n', '\n', '    function isOpen() public view returns (bool) {\n', '        return hasStarted() && !hasFinalized();\n', '    }\n', '\n', '    function hasMinimumAmount() public view returns (bool) {\n', '        return (individualMinimumAmount != 0);\n', '    }\n', '\n', '    function cost(uint256 _amount) public view returns (uint256) {\n', '        return _amount.mul(tradeValue).div(10**decimals);\n', '    }\n', '\n', '    function getPurchase(uint256 _purchase_id)\n', '        external\n', '        view\n', '        returns (\n', '            uint256,\n', '            address,\n', '            uint256,\n', '            uint256,\n', '            bool,\n', '            bool\n', '        )\n', '    {\n', '        Purchase memory purchase = purchases[_purchase_id];\n', '        return (purchase.amount, purchase.purchaser, purchase.ethAmount, purchase.timestamp, purchase.wasFinalized, purchase.reverted);\n', '    }\n', '\n', '    function getPurchaseIds() public view returns (uint256[] memory) {\n', '        return purchaseIds;\n', '    }\n', '\n', '    function getBuyers() public view returns (address[] memory) {\n', '        return buyers;\n', '    }\n', '\n', '    function getMyPurchases(address _address) public view returns (uint256[] memory) {\n', '        return myPurchases[_address];\n', '    }\n', '\n', '    /* Fund - Pre Sale Start */\n', '    function fund(uint256 _amount) public isSalePreStarted {\n', '        /* Confirm transferred tokens is no more than needed */\n', '        require(availableTokens().add(_amount) <= tokensForSale, "Transferred tokens have to be equal or less than proposed");\n', '\n', '        /* Transfer Funds */\n', '        TransferHelper.safeTransferFrom(address(erc20), msg.sender, address(this), _amount);\n', '        /* If Amount is equal to needed - sale is ready */\n', '        if (availableTokens() == tokensForSale) {\n', '            isSaleFunded = true;\n', '        }\n', '        emit FundEvent(msg.sender, _amount, address(this), block.timestamp);\n', '    }\n', '\n', '    /* Action Functions */\n', '    function swap(uint256 _amount) external payable whenNotPaused isFunded isSaleOpen onlyWhitelisted blockReentrancy {\n', '        /* Confirm Amount is positive */\n', '        require(_amount > 0, "Amount has to be positive");\n', '\n', '        /* Confirm Amount is less than tokens available */\n', '        require(_amount <= tokensLeft(), "Amount is less than tokens available");\n', '\n', '        /* Confirm the user has funds for the transfer, confirm the value is equal */\n', '        require(msg.value == cost(_amount), "User swap amount has to equal to cost of token in ETH");\n', '\n', '        /* Confirm Amount is bigger than minimum Amount */\n', '        require(_amount >= individualMinimumAmount, "Amount is bigger than minimum amount");\n', '\n', '        /* Confirm Amount is smaller than maximum Amount */\n', '        require(_amount <= individualMaximumAmount, "Amount is smaller than maximum amount");\n', '\n', '        /* Verify all user purchases, loop thru them */\n', '        uint256[] memory _purchases = getMyPurchases(msg.sender);\n', '        uint256 purchaserTotalAmountPurchased = 0;\n', '        for (uint i = 0; i < _purchases.length; i++) {\n', '            Purchase memory _purchase = purchases[_purchases[i]];\n', '            purchaserTotalAmountPurchased = purchaserTotalAmountPurchased.add(_purchase.amount);\n', '        }\n', '        require(purchaserTotalAmountPurchased.add(_amount) <= individualMaximumAmount, "Address has already passed the max amount of swap");\n', '\n', '        if (isTokenSwapAtomic) {\n', '            /* Confirm transfer */\n', '            TransferHelper.safeTransfer(address(erc20), msg.sender, _amount);\n', '        }\n', '\n', '        uint256 purchase_id = increment;\n', '        increment = increment.add(1);\n', '\n', '        /* Create new purchase */\n', '        Purchase memory purchase =\n', '            Purchase(\n', '                _amount,\n', '                msg.sender,\n', '                msg.value,\n', '                block.timestamp,\n', '                isTokenSwapAtomic, /* If Atomic Swap */\n', '                false\n', '            );\n', '        purchases[purchase_id] = purchase;\n', '        purchaseIds.push(purchase_id);\n', '        myPurchases[msg.sender].push(purchase_id);\n', '        buyers.push(msg.sender);\n', '        tokensAllocated = tokensAllocated.add(_amount);\n', '        emit PurchaseEvent(purchase_id, _amount, msg.sender, msg.value, block.timestamp, isTokenSwapAtomic);\n', '    }\n', '\n', '    /* Redeem tokens when the sale was finalized */\n', '    function redeemTokens(uint256 purchase_id) external isNotAtomicSwap isSaleFinalized whenNotPaused blockReentrancy {\n', '        /* Confirm it exists and was not finalized */\n', '        require((purchases[purchase_id].amount != 0) && !purchases[purchase_id].wasFinalized, "Purchase is either 0 or finalized");\n', '        require(isBuyer(purchase_id), "Address is not buyer");\n', '        purchases[purchase_id].wasFinalized = true;\n', '        TransferHelper.safeTransfer(address(erc20), msg.sender, purchases[purchase_id].amount);\n', '        emit RedeemTokenEvent(purchase_id, purchases[purchase_id].amount, msg.sender, 0, purchases[purchase_id].wasFinalized, false);\n', '    }\n', '\n', '    /* Retrieve Minimum Amount */\n', '    function redeemGivenMinimumGoalNotAchieved(uint256 purchase_id) external isSaleFinalized isNotAtomicSwap whenNotPaused blockReentrancy {\n', '        require(hasMinimumRaise(), "Minimum raise has to exist");\n', '        require(minimumRaiseNotAchieved(), "Minimum raise has to be reached");\n', '        /* Confirm it exists and was not finalized */\n', '        require((purchases[purchase_id].amount != 0) && !purchases[purchase_id].wasFinalized, "Purchase is either 0 or finalized");\n', '        require(isBuyer(purchase_id), "Address is not buyer");\n', '        purchases[purchase_id].wasFinalized = true;\n', '        purchases[purchase_id].reverted = true;\n', '        msg.sender.transfer(purchases[purchase_id].ethAmount);\n', '        emit RedeemTokenEvent(\n', '            purchase_id,\n', '            0,\n', '            msg.sender,\n', '            purchases[purchase_id].ethAmount,\n', '            purchases[purchase_id].wasFinalized,\n', '            purchases[purchase_id].reverted\n', '        );\n', '    }\n', '\n', '    /* Admin Functions */\n', '    function withdrawFunds() external onlyOwner whenNotPaused isSaleFinalized {\n', '        require(minimumRaiseAchieved(), "Minimum raise has to be reached");\n', '        uint256 fee = address(this).balance.mul(feePercentage).div(100);\n', '        feeAddress.transfer(fee); /* Fee Address */\n', '        uint256 funds = address(this).balance;\n', '        msg.sender.transfer(funds);\n', '    }\n', '\n', '    function withdrawUnsoldTokens() external onlyOwner isSaleFinalized {\n', '        require(!unsoldTokensRedeemed);\n', '        uint256 unsoldTokens;\n', '        if (hasMinimumRaise() && (cost(tokensAllocated) < cost(minimumRaise))) {\n', '            /* Minimum Raise not reached */\n', '            unsoldTokens = tokensForSale;\n', '        } else {\n', '            /* If minimum Raise Achieved Redeem All Tokens minus the ones */\n', '            unsoldTokens = tokensForSale.sub(tokensAllocated);\n', '        }\n', '\n', '        if (unsoldTokens > 0) {\n', '            unsoldTokensRedeemed = true;\n', '            TransferHelper.safeTransfer(address(erc20), msg.sender, unsoldTokens);\n', '        }\n', '    }\n', '\n', '    function removeOtherERC20Tokens(address _tokenAddress, address _to) external onlyOwner isSaleFinalized {\n', '        require(_tokenAddress != address(erc20), "Token Address has to be diff than the erc20 subject to sale"); // Confirm tokens addresses are different from main sale one\n', '        IERC20Detailed erc20Token = IERC20Detailed(_tokenAddress);\n', '        TransferHelper.safeTransfer(address(erc20Token), _to, erc20Token.balanceOf(address(this)));\n', '    }\n', '\n', '    function pause() external onlyOwner {\n', '        _pause();\n', '    }\n', '\n', '    /* Safe Pull function */\n', '    function safePull() external payable onlyOwner whenPaused {\n', '        msg.sender.transfer(address(this).balance);\n', '        TransferHelper.safeTransfer(address(erc20), msg.sender, erc20.balanceOf(address(this)));\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.6;\n', '\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', 'interface IERC20Detailed is IERC20 {\n', '\n', '    function decimals() external view returns (uint8);\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "./Context.sol";\n', '\n', '/**\n', ' * @dev Contract module which allows children to implement an emergency stop\n', ' * mechanism that can be triggered by an authorized account.\n', ' *\n', ' * This module is used through inheritance. It will make available the\n', ' * modifiers `whenNotPaused` and `whenPaused`, which can be applied to\n', ' * the functions of your contract. Note that they will not be pausable by\n', ' * simply including this module, only once the modifiers are put in place.\n', ' */\n', 'abstract contract Pausable is Context {\n', '    /**\n', '     * @dev Emitted when the pause is triggered by `account`.\n', '     */\n', '    event Paused(address account);\n', '\n', '    /**\n', '     * @dev Emitted when the pause is lifted by `account`.\n', '     */\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    /**\n', '     * @dev Initializes the contract in unpaused state.\n', '     */\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the contract is paused, and false otherwise.\n', '     */\n', '    function paused() public view virtual returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused(), "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused(), "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Triggers stopped state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    function _pause() internal virtual whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(_msgSender());\n', '    }\n', '\n', '    /**\n', '     * @dev Returns to normal state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    function _unpause() internal virtual whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(_msgSender());\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.6;\n', '\n', 'import "@openzeppelin/contracts/access/Ownable.sol";\n', '\n', 'contract Whitelist is Ownable {\n', '    mapping(address => bool) public whitelist;\n', '    address[] public whitelistedAddresses;\n', '    bool public hasWhitelisting = false;\n', '\n', '    event AddedToWhitelist(address[] accounts);\n', '    event RemovedFromWhitelist(address indexed account);\n', '\n', '    modifier onlyWhitelisted() {\n', '        if (hasWhitelisting) {\n', '            require(isWhitelisted(msg.sender), "Must be in the whitelist");\n', '        }\n', '        _;\n', '    }\n', '\n', '    constructor(bool _hasWhitelisting) {\n', '        hasWhitelisting = _hasWhitelisting;\n', '    }\n', '\n', '    function add(address[] memory _addresses) public onlyOwner {\n', '        for (uint i = 0; i < _addresses.length; i++) {\n', '            require(whitelist[_addresses[i]] != true);\n', '            whitelist[_addresses[i]] = true;\n', '            whitelistedAddresses.push(_addresses[i]);\n', '        }\n', '        emit AddedToWhitelist(_addresses);\n', '    }\n', '\n', '    function remove(address _address, uint256 _index) public onlyOwner {\n', '        require(_address == whitelistedAddresses[_index]);\n', '        whitelist[_address] = false;\n', '        delete whitelistedAddresses[_index];\n', '        emit RemovedFromWhitelist(_address);\n', '    }\n', '\n', '    function getWhitelistedAddresses() public view returns (address[] memory) {\n', '        return whitelistedAddresses;\n', '    }\n', '\n', '    function isWhitelisted(address _address) public view returns (bool) {\n', '        return whitelist[_address];\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', '// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\n', 'library TransferHelper {\n', '    function safeApprove(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');\n", '    }\n', '\n', '    function safeTransfer(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');\n", '    }\n', '\n', '    function safeTransferFrom(address token, address from, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');\n", '    }\n', '\n', '    function safeTransferETH(address to, uint value) internal {\n', '        (bool success,) = to.call{value:value}(new bytes(0));\n', "        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');\n", '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "../utils/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 999999\n', '  },\n', '  "evmVersion": "istanbul",\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "metadata": {\n', '    "useLiteralContent": true\n', '  },\n', '  "libraries": {}\n', '}']