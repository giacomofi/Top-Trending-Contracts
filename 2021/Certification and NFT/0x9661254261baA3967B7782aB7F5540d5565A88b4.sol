['// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./libraries/IERC20.sol";\n', 'import "./libraries/FullMath.sol";\n', 'import "./MinterReceiver.sol";\n', '\n', '/// @title HEX Share Market\n', '/// @author Sam Presnal - Staker\n', '/// @dev Sell shares priced at the original purchase rate\n', '/// plus the applied premium\n', 'contract ShareMarket is MinterReceiver {\n', '    IERC20 public immutable hexContract;\n', '    address public immutable minterContract;\n', '\n', '    /// @dev Share price is sharesBalance/heartsBalance\n', '    /// Both balances reduce on buyShares to maintain the price,\n', '    /// keep track of hearts owed to supplier, and determine\n', '    /// when the listing is no longer buyable\n', '    struct ShareListing {\n', '        uint72 sharesBalance;\n', '        uint72 heartsBalance;\n', '    }\n', '    mapping(uint40 => ShareListing) public shareListings;\n', '\n', '    /// @dev The values are initialized onSharesMinted and\n', '    /// onEarningsMinted respectively. Used to calculate personal\n', '    /// earnings for a listing sharesOwned/sharesTotal*heartsEarned\n', '    struct ShareEarnings {\n', '        uint72 sharesTotal;\n', '        uint72 heartsEarned;\n', '    }\n', '    mapping(uint40 => ShareEarnings) public shareEarnings;\n', '\n', '    /// @notice Maintains which addresses own shares of particular stakes\n', '    /// @dev heartsOwed is only set for the supplier to keep track of\n', '    /// repayment for creating the stake\n', '    struct ListingOwnership {\n', '        uint72 sharesOwned;\n', '        uint72 heartsOwed;\n', '        bool isSupplier;\n', '    }\n', '    //keccak(stakeId, address) => ListingOwnership\n', '    mapping(bytes32 => ListingOwnership) internal shareOwners;\n', '\n', '    struct ShareOrder {\n', '        uint40 stakeId;\n', '        uint256 sharesPurchased;\n', '        address shareReceiver;\n', '    }\n', '\n', '    event AddListing(\n', '        uint40 indexed stakeId,\n', '        address indexed supplier,\n', '        uint256 data0 //shares | hearts << 72\n', '    );\n', '    event AddEarnings(uint40 indexed stakeId, uint256 heartsEarned);\n', '    event BuyShares(\n', '        uint40 indexed stakeId,\n', '        address indexed owner,\n', '        uint256 data0, //sharesPurchased | sharesOwned << 72\n', '        uint256 data1 //sharesBalance | heartsBalance << 72\n', '    );\n', '    event ClaimEarnings(uint40 indexed stakeId, address indexed claimer, uint256 heartsClaimed);\n', '    event SupplierWithdraw(uint40 indexed stakeId, address indexed supplier, uint256 heartsWithdrawn);\n', '\n', '    uint256 private unlocked = 1;\n', '    modifier lock() {\n', '        require(unlocked == 1, "LOCKED");\n', '        unlocked = 0;\n', '        _;\n', '        unlocked = 1;\n', '    }\n', '\n', '    constructor(IERC20 _hex, address _minter) {\n', '        hexContract = _hex;\n', '        minterContract = _minter;\n', '    }\n', '\n', '    /// @inheritdoc MinterReceiver\n', '    function onSharesMinted(\n', '        uint40 stakeId,\n', '        address supplier,\n', '        uint72 stakedHearts,\n', '        uint72 stakeShares\n', '    ) external override {\n', '        require(msg.sender == minterContract, "CALLER_NOT_MINTER");\n', '\n', '        //Seed pool with shares and hearts determining the rate\n', '        shareListings[stakeId] = ShareListing(stakeShares, stakedHearts);\n', '\n', '        //Store total shares to calculate user earnings for claiming\n', '        shareEarnings[stakeId].sharesTotal = stakeShares;\n', '\n', '        //Store how many hearts the supplier needs to be paid back\n', '        shareOwners[_hash(stakeId, supplier)] = ListingOwnership(0, stakedHearts, true);\n', '\n', '        emit AddListing(stakeId, supplier, uint256(uint72(stakeShares)) | (uint256(uint72(stakedHearts)) << 72));\n', '    }\n', '\n', '    /// @inheritdoc MinterReceiver\n', '    function onEarningsMinted(uint40 stakeId, uint72 heartsEarned) external override {\n', '        require(msg.sender == minterContract, "CALLER_NOT_MINTER");\n', '        //Hearts earned and total shares now stored in earnings\n', '        //for payout calculations\n', '        shareEarnings[stakeId].heartsEarned = heartsEarned;\n', '        emit AddEarnings(stakeId, heartsEarned);\n', '    }\n', '\n', '    /// @return Supplier hearts payable resulting from user purchases\n', '    function supplierHeartsPayable(uint40 stakeId, address supplier) external view returns (uint256) {\n', '        uint256 heartsOwed = shareOwners[_hash(stakeId, supplier)].heartsOwed;\n', '        if (heartsOwed == 0) return 0;\n', '        (uint256 heartsBalance, ) = listingBalances(stakeId);\n', '        return heartsOwed - heartsBalance;\n', '    }\n', '\n', '    /// @dev Used to calculate share price\n', '    /// @return hearts Balance of hearts remaining in the listing to be input\n', '    /// @return shares Balance of shares reamining in the listing to be sold\n', '    function listingBalances(uint40 stakeId) public view returns (uint256 hearts, uint256 shares) {\n', '        ShareListing memory listing = shareListings[stakeId];\n', '        hearts = listing.heartsBalance;\n', '        shares = listing.sharesBalance;\n', '    }\n', '\n', '    /// @dev Used to calculate personal earnings\n', '    /// @return heartsEarned Total hearts earned by the stake\n', '    /// @return sharesTotal Total shares originally on the market\n', '    function listingEarnings(uint40 stakeId) public view returns (uint256 heartsEarned, uint256 sharesTotal) {\n', '        ShareEarnings memory earnings = shareEarnings[stakeId];\n', '        heartsEarned = earnings.heartsEarned;\n', '        sharesTotal = earnings.sharesTotal;\n', '    }\n', '\n', '    /// @dev Shares owned is set to 0 when a user claims earnings\n', '    /// @return Current shares owned of a particular listing\n', '    function sharesOwned(uint40 stakeId, address owner) public view returns (uint256) {\n', '        return shareOwners[_hash(stakeId, owner)].sharesOwned;\n', '    }\n', '\n', '    /// @dev Hash together stakeId and address to form a key for\n', '    /// storage access\n', '    /// @return Listing address storage key\n', '    function _hash(uint40 stakeId, address addr) internal pure returns (bytes32) {\n', '        return keccak256(abi.encodePacked(stakeId, addr));\n', '    }\n', '\n', '    /// @notice Allows user to purchase shares from multiple listings\n', '    /// @dev Lumps owed HEX into single transfer\n', '    function multiBuyShares(ShareOrder[] memory orders) external lock {\n', '        uint256 totalHeartsOwed;\n', '        for (uint256 i = 0; i < orders.length; i++) {\n', '            ShareOrder memory order = orders[i];\n', '            totalHeartsOwed += _buyShares(order.stakeId, order.shareReceiver, order.sharesPurchased);\n', '        }\n', '\n', '        hexContract.transferFrom(msg.sender, address(this), totalHeartsOwed);\n', '    }\n', '\n', '    /// @notice Allows user to purchase shares from a single listing\n', '    /// @param stakeId HEX stakeId to purchase shares from\n', '    /// @param shareReceiver The receiver of the shares being purchased\n', '    /// @param sharesPurchased The number of shares to purchase\n', '    function buyShares(\n', '        uint40 stakeId,\n', '        address shareReceiver,\n', '        uint256 sharesPurchased\n', '    ) external lock {\n', '        uint256 heartsOwed = _buyShares(stakeId, shareReceiver, sharesPurchased);\n', '        hexContract.transferFrom(msg.sender, address(this), heartsOwed);\n', '    }\n', '\n', '    function _buyShares(\n', '        uint40 stakeId,\n', '        address shareReceiver,\n', '        uint256 sharesPurchased\n', '    ) internal returns (uint256 heartsOwed) {\n', '        require(sharesPurchased != 0, "INSUFFICIENT_SHARES_PURCHASED");\n', '\n', '        (uint256 _heartsBalance, uint256 _sharesBalance) = listingBalances(stakeId);\n', '        require(sharesPurchased <= _sharesBalance, "INSUFFICIENT_SHARES_AVAILABLE");\n', '\n', '        //mulDivRoundingUp may result in 1 extra heart cost\n', '        //any shares purchased will always cost at least 1 heart\n', '        heartsOwed = FullMath.mulDivRoundingUp(sharesPurchased, _heartsBalance, _sharesBalance);\n', '\n', '        //Reduce hearts owed to remaining hearts balance if it exceeds it\n', '        //This can happen from extra 1 heart cost\n', '        if (heartsOwed >= _heartsBalance) {\n', '            heartsOwed = _heartsBalance;\n', '            sharesPurchased = _sharesBalance;\n', '        }\n', '\n', '        //Reduce both sides of the pool to maintain price\n', '        uint256 sharesBalance = _sharesBalance - sharesPurchased;\n', '        uint256 heartsBalance = _heartsBalance - heartsOwed;\n', '        shareListings[stakeId] = ShareListing(uint72(sharesBalance), uint72(heartsBalance));\n', '\n', '        //Add shares purchased to currently owned shares if any\n', '        bytes32 shareOwner = _hash(stakeId, shareReceiver);\n', '        uint256 newSharesOwned = shareOwners[shareOwner].sharesOwned + sharesPurchased;\n', '        shareOwners[shareOwner].sharesOwned = uint72(newSharesOwned);\n', '        emit BuyShares(\n', '            stakeId,\n', '            shareReceiver,\n', '            uint256(uint72(sharesPurchased)) | (uint256(uint72(newSharesOwned)) << 72),\n', '            uint256(uint72(sharesBalance)) | (uint256(uint72(heartsBalance)) << 72)\n', '        );\n', '    }\n', '\n', '    /// @notice Withdraw earnings as a supplier\n', '    /// @param stakeId HEX stakeId to withdraw earnings from\n', '    /// @dev Combines supplier withdraw from two sources\n', '    /// 1. Hearts paid for supplied shares by market participants\n', '    /// 2. Hearts earned from staking supplied shares (buyer fee %)\n', '    /// Note: If a listing has ended, assigns all leftover shares before withdraw\n', '    function supplierWithdraw(uint40 stakeId) external lock {\n', '        //Track total withdrawable\n', '        uint256 totalHeartsOwed = 0;\n', '        bytes32 supplier = _hash(stakeId, msg.sender);\n', '        require(shareOwners[supplier].isSupplier, "NOT_SUPPLIER");\n', '\n', '        //Check to see if heartsOwed for sold shares in listing\n', '        uint256 heartsOwed = uint256(shareOwners[supplier].heartsOwed);\n', '        (uint256 heartsBalance, uint256 sharesBalance) = listingBalances(stakeId);\n', '        //The delta between heartsOwed and heartsBalance is created\n', '        //by users buying shares from the pool and reducing heartsBalance\n', '        if (heartsOwed > heartsBalance) {\n', '            //Withdraw any hearts for shares sold\n', '            uint256 heartsPayable = heartsOwed - heartsBalance;\n', '            uint256 newHeartsOwed = heartsOwed - heartsPayable;\n', '            //Update hearts owed\n', '            shareOwners[supplier].heartsOwed = uint72(newHeartsOwed);\n', '\n', '            totalHeartsOwed = heartsPayable;\n', '        }\n', '\n', '        //Claim earnings including unsold shares only if the\n', '        //earnings have already been minted\n', '        (uint256 heartsEarned, ) = listingEarnings(stakeId);\n', '        if (heartsEarned != 0) {\n', '            uint256 supplierShares = shareOwners[supplier].sharesOwned;\n', '\n', '            //Check for unsold market shares\n', '            if (sharesBalance != 0) {\n', '                //Add unsold shares to supplier shares\n', '                supplierShares += sharesBalance;\n', '                //Update storage to reflect new shares\n', '                shareOwners[supplier].sharesOwned = uint72(supplierShares);\n', '                //Close buying from share listing\n', '                delete shareListings[stakeId];\n', '                //Remove supplier hearts owed\n', '                shareOwners[supplier].heartsOwed = 0;\n', '                emit BuyShares(\n', '                    stakeId,\n', '                    msg.sender,\n', '                    uint256(uint72(sharesBalance)) | (uint256(supplierShares) << 72),\n', '                    0\n', '                );\n', '            }\n', '\n', '            //Ensure supplier has shares (claim reverts otherwise)\n', '            if (supplierShares != 0) totalHeartsOwed += _claimEarnings(stakeId);\n', '        }\n', '\n', '        require(totalHeartsOwed != 0, "NO_HEARTS_OWED");\n', '        hexContract.transfer(msg.sender, totalHeartsOwed);\n', '        emit SupplierWithdraw(stakeId, msg.sender, totalHeartsOwed);\n', '    }\n', '\n', '    /// @notice Withdraw earnings as a market participant\n', '    /// @param stakeId HEX stakeId to withdraw earnings from\n', '    function claimEarnings(uint40 stakeId) external lock {\n', '        uint256 heartsEarned = _claimEarnings(stakeId);\n', '        require(heartsEarned != 0, "NO_HEARTS_EARNED");\n', '        hexContract.transfer(msg.sender, heartsEarned);\n', '    }\n', '\n', '    function _claimEarnings(uint40 stakeId) internal returns (uint256 heartsOwed) {\n', '        (uint256 heartsEarned, uint256 sharesTotal) = listingEarnings(stakeId);\n', '        require(sharesTotal != 0, "LISTING_NOT_FOUND");\n', '        require(heartsEarned != 0, "SHARES_NOT_MATURE");\n', '\n', '        bytes32 owner = _hash(stakeId, msg.sender);\n', '        uint256 ownedShares = shareOwners[owner].sharesOwned;\n', '        require(ownedShares != 0, "NO_SHARES_OWNED");\n', '\n', '        heartsOwed = FullMath.mulDiv(heartsEarned, ownedShares, sharesTotal);\n', '        shareOwners[owner].sharesOwned = 0;\n', '        emit ClaimEarnings(stakeId, msg.sender, heartsOwed);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.4.0;\n', '\n', '/// @title Contains 512-bit math functions\n', '/// @notice Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision\n', '/// @dev Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits\n', 'library FullMath {\n', '    /// @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0\n', '    /// @param a The multiplicand\n', '    /// @param b The multiplier\n', '    /// @param denominator The divisor\n', '    /// @return result The 256-bit result\n', '    /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv\n', '    function mulDiv(\n', '        uint256 a,\n', '        uint256 b,\n', '        uint256 denominator\n', '    ) internal pure returns (uint256 result) {\n', '        // 512-bit multiply [prod1 prod0] = a * b\n', '        // Compute the product mod 2**256 and mod 2**256 - 1\n', '        // then use the Chinese Remainder Theorem to reconstruct\n', '        // the 512 bit result. The result is stored in two 256\n', '        // variables such that product = prod1 * 2**256 + prod0\n', '        uint256 prod0; // Least significant 256 bits of the product\n', '        uint256 prod1; // Most significant 256 bits of the product\n', '        assembly {\n', '            let mm := mulmod(a, b, not(0))\n', '            prod0 := mul(a, b)\n', '            prod1 := sub(sub(mm, prod0), lt(mm, prod0))\n', '        }\n', '\n', '        // Handle non-overflow cases, 256 by 256 division\n', '        if (prod1 == 0) {\n', '            require(denominator > 0);\n', '            assembly {\n', '                result := div(prod0, denominator)\n', '            }\n', '            return result;\n', '        }\n', '\n', '        // Make sure the result is less than 2**256.\n', '        // Also prevents denominator == 0\n', '        require(denominator > prod1);\n', '\n', '        ///////////////////////////////////////////////\n', '        // 512 by 256 division.\n', '        ///////////////////////////////////////////////\n', '\n', '        // Make division exact by subtracting the remainder from [prod1 prod0]\n', '        // Compute remainder using mulmod\n', '        uint256 remainder;\n', '        assembly {\n', '            remainder := mulmod(a, b, denominator)\n', '        }\n', '        // Subtract 256 bit number from 512 bit number\n', '        assembly {\n', '            prod1 := sub(prod1, gt(remainder, prod0))\n', '            prod0 := sub(prod0, remainder)\n', '        }\n', '\n', '        // Factor powers of two out of denominator\n', '        // Compute largest power of two divisor of denominator.\n', '        // Always >= 1.\n', '        uint256 twos = (type(uint256).max - denominator + 1) & denominator;\n', '        // Divide denominator by power of two\n', '        assembly {\n', '            denominator := div(denominator, twos)\n', '        }\n', '\n', '        // Divide [prod1 prod0] by the factors of two\n', '        assembly {\n', '            prod0 := div(prod0, twos)\n', '        }\n', '        // Shift in bits from prod1 into prod0. For this we need\n', '        // to flip `twos` such that it is 2**256 / twos.\n', '        // If twos is zero, then it becomes one\n', '        assembly {\n', '            twos := add(div(sub(0, twos), twos), 1)\n', '        }\n', '        prod0 |= prod1 * twos;\n', '\n', '        // Invert denominator mod 2**256\n', '        // Now that denominator is an odd number, it has an inverse\n', '        // modulo 2**256 such that denominator * inv = 1 mod 2**256.\n', '        // Compute the inverse by starting with a seed that is correct\n', '        // correct for four bits. That is, denominator * inv = 1 mod 2**4\n', '        uint256 inv = (3 * denominator) ^ 2;\n', '        // Now use Newton-Raphson iteration to improve the precision.\n', "        // Thanks to Hensel's lifting lemma, this also works in modular\n", '        // arithmetic, doubling the correct bits in each step.\n', '        inv *= 2 - denominator * inv; // inverse mod 2**8\n', '        inv *= 2 - denominator * inv; // inverse mod 2**16\n', '        inv *= 2 - denominator * inv; // inverse mod 2**32\n', '        inv *= 2 - denominator * inv; // inverse mod 2**64\n', '        inv *= 2 - denominator * inv; // inverse mod 2**128\n', '        inv *= 2 - denominator * inv; // inverse mod 2**256\n', '\n', '        // Because the division is now exact we can divide by multiplying\n', '        // with the modular inverse of denominator. This will give us the\n', '        // correct result modulo 2**256. Since the precoditions guarantee\n', '        // that the outcome is less than 2**256, this is the final result.\n', "        // We don't need to compute the high bits of the result and prod1\n", '        // is no longer required.\n', '        result = prod0 * inv;\n', '        return result;\n', '    }\n', '\n', '    /// @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0\n', '    /// @param a The multiplicand\n', '    /// @param b The multiplier\n', '    /// @param denominator The divisor\n', '    /// @return result The 256-bit result\n', '    function mulDivRoundingUp(\n', '        uint256 a,\n', '        uint256 b,\n', '        uint256 denominator\n', '    ) internal pure returns (uint256 result) {\n', '        result = mulDiv(a, b, denominator);\n', '        if (mulmod(a, b, denominator) > 0) {\n', '            require(result < type(uint256).max);\n', '            result++;\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./libraries/ERC165.sol";\n', '\n', '/// @title HEX Minter Receiver\n', '/// @author Sam Presnal - Staker\n', '/// @dev Receives shares and hearts earned from the ShareMinter\n', 'abstract contract MinterReceiver is ERC165 {\n', '    /// @notice ERC165 ensures the minter receiver supports the interface\n', '    /// @param interfaceId The MinterReceiver interface id\n', '    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {\n', '        return interfaceId == type(MinterReceiver).interfaceId || super.supportsInterface(interfaceId);\n', '    }\n', '\n', '    /// @notice Receives newly started stake properties\n', '    /// @param stakeId The HEX stakeId\n', '    /// @param supplier The reimbursement address for the supplier\n', '    /// @param stakedHearts Hearts staked\n', '    /// @param stakeShares Shares available\n', '    function onSharesMinted(\n', '        uint40 stakeId,\n', '        address supplier,\n', '        uint72 stakedHearts,\n', '        uint72 stakeShares\n', '    ) external virtual;\n', '\n', '    /// @notice Receives newly ended stake properties\n', '    /// @param stakeId The HEX stakeId\n', '    /// @param heartsEarned Hearts earned from the stake\n', '    function onEarningsMinted(uint40 stakeId, uint72 heartsEarned) external virtual;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./IERC165.sol";\n', '\n', '/**\n', ' * @dev Implementation of the {IERC165} interface.\n', ' *\n', ' * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check\n', ' * for the additional interface id that will be supported. For example:\n', ' *\n', ' * ```solidity\n', ' * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {\n', ' *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);\n', ' * }\n', ' * ```\n', ' *\n', ' * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.\n', ' */\n', 'abstract contract ERC165 is IERC165 {\n', '    /**\n', '     * @dev See {IERC165-supportsInterface}.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {\n', '        return interfaceId == type(IERC165).interfaceId;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 999999\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']