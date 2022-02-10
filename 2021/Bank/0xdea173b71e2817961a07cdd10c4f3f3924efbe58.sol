['pragma solidity ^0.5.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import "./libs.sol";\n', 'import "./Roles.sol";\n', 'import "./ERC165.sol";\n', 'import "./IERC20.sol";\n', 'import "./TransferProxy.sol";\n', '\n', '/// @title ExchangeDomainV1\n', '/// @notice Describes all the structs that are used in exchnages.\n', 'contract ExchangeDomainV1 {\n', '\n', '    enum AssetType {ETH, ERC20, ERC1155, ERC721, ERC721Deprecated}\n', '\n', '    struct Asset {\n', '        address token;\n', '        uint tokenId;\n', '        AssetType assetType;\n', '    }\n', '\n', '    struct OrderKey {\n', '        /* who signed the order */\n', '        address owner;\n', '        /* random number */\n', '        uint salt;\n', '\n', '        /* what has owner */\n', '        Asset sellAsset;\n', '\n', '        /* what wants owner */\n', '        Asset buyAsset;\n', '    }\n', '\n', '    struct Order {\n', '        OrderKey key;\n', '\n', '        /* how much has owner (in wei, or UINT256_MAX if ERC-721) */\n', '        uint selling;\n', '        /* how much wants owner (in wei, or UINT256_MAX if ERC-721) */\n', '        uint buying;\n', '\n', '        /* fee for selling. Represented as percents * 100 (100% - 10000. 1% - 100)*/\n', '        uint sellerFee;\n', '    }\n', '\n', '    /* An ECDSA signature. */\n', '    struct Sig {\n', '        /* v parameter */\n', '        uint8 v;\n', '        /* r parameter */\n', '        bytes32 r;\n', '        /* s parameter */\n', '        bytes32 s;\n', '    }\n', '}\n', '\n', '/// @title ExchangeStateV1\n', '/// @notice Tracks the amount of selled tokens in the order.\n', 'contract ExchangeStateV1 is OwnableOperatorRole {\n', '\n', '    // keccak256(OrderKey) => completed\n', '    mapping(bytes32 => uint256) public completed;\n', '\n', '    /// @notice Get the amount of selled tokens.\n', '    /// @param key - the `OrderKey` struct.\n', '    /// @return Selled tokens count for the order.\n', '    function getCompleted(ExchangeDomainV1.OrderKey calldata key) view external returns (uint256) {\n', '        return completed[getCompletedKey(key)];\n', '    }\n', '\n', '    /// @notice Sets the new amount of selled tokens. Can be called only by the contract operator.\n', '    /// @param key - the `OrderKey` struct.\n', '    /// @param newCompleted - The new value to set.\n', '    function setCompleted(ExchangeDomainV1.OrderKey calldata key, uint256 newCompleted) external onlyOperator {\n', '        completed[getCompletedKey(key)] = newCompleted;\n', '    }\n', '\n', '    /// @notice Encode order key to use as the mapping key.\n', '    /// @param key - the `OrderKey` struct.\n', '    /// @return Encoded order key.\n', '    function getCompletedKey(ExchangeDomainV1.OrderKey memory key) pure public returns (bytes32) {\n', '        return keccak256(abi.encodePacked(key.owner, key.sellAsset.token, key.sellAsset.tokenId, key.buyAsset.token, key.buyAsset.tokenId, key.salt));\n', '    }\n', '}\n', '\n', '/// @title ExchangeOrdersHolderV1\n', "/// @notice Optionally holds orders, which can be exchanged without order's holder signature.\n", 'contract ExchangeOrdersHolderV1 {\n', '\n', '    mapping(bytes32 => OrderParams) internal orders;\n', '\n', '    struct OrderParams {\n', '        /* how much has owner (in wei, or UINT256_MAX if ERC-721) */\n', '        uint selling;\n', '        /* how much wants owner (in wei, or UINT256_MAX if ERC-721) */\n', '        uint buying;\n', '\n', '        /* fee for selling */\n', '        uint sellerFee;\n', '    }\n', '\n', '    /// @notice This function can be called to add the order to the contract, so it can be exchanged without signature.\n', '    ///         Can be called only by the order owner.\n', '    /// @param order - The order struct to add.\n', '    function add(ExchangeDomainV1.Order calldata order) external {\n', '        require(msg.sender == order.key.owner, "order could be added by owner only");\n', '        bytes32 key = prepareKey(order);\n', '        orders[key] = OrderParams(order.selling, order.buying, order.sellerFee);\n', '    }\n', '\n', '    /// @notice This function checks if order was added to the orders holder contract.\n', '    /// @param order - The order struct to check.\n', "    /// @return true if order is present in the contract's data.\n", '    function exists(ExchangeDomainV1.Order calldata order) external view returns (bool) {\n', '        bytes32 key = prepareKey(order);\n', '        OrderParams memory params = orders[key];\n', '        return params.buying == order.buying && params.selling == order.selling && params.sellerFee == order.sellerFee;\n', '    }\n', '\n', '    function prepareKey(ExchangeDomainV1.Order memory order) internal pure returns (bytes32) {\n', '        return keccak256(abi.encode(\n', '                order.key.sellAsset.token,\n', '                order.key.sellAsset.tokenId,\n', '                order.key.owner,\n', '                order.key.buyAsset.token,\n', '                order.key.buyAsset.tokenId,\n', '                order.key.salt\n', '            ));\n', '    }\n', '}\n', '\n', '/// @title Token Exchange contract.\n', '/// @notice Supports ETH, ERC20, ERC721 and ERC1155 tokens.\n', '/// @notice This contracts relies on offchain signatures for order and fees verification.\n', 'contract ExchangeV1 is Ownable, ExchangeDomainV1 {\n', '    using SafeMath for uint;\n', '    using UintLibrary for uint;\n', '    using StringLibrary for string;\n', '    using BytesLibrary for bytes32;\n', '\n', '    enum FeeSide {NONE, SELL, BUY}\n', '\n', '    event Buy(\n', '        address indexed sellToken, uint256 indexed sellTokenId, uint256 sellValue,\n', '        address owner,\n', '        address buyToken, uint256 buyTokenId, uint256 buyValue,\n', '        address buyer,\n', '        uint256 amount,\n', '        uint256 salt\n', '    );\n', '\n', '    event Cancel(\n', '        address indexed sellToken, uint256 indexed sellTokenId,\n', '        address owner,\n', '        address buyToken, uint256 buyTokenId,\n', '        uint256 salt\n', '    );\n', '\n', '    bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;\n', '    uint256 private constant UINT256_MAX = 2 ** 256 - 1;\n', '\n', '    address payable public beneficiary;\n', '    address public buyerFeeSigner;\n', '\n', '    /// @notice The address of a transfer proxy for ERC721 and ERC1155 tokens.\n', '    TransferProxy public transferProxy;\n', '    /// @notice The address of a transfer proxy for deprecated ERC721 tokens. Does not use safe transfer.\n', '    TransferProxyForDeprecated public transferProxyForDeprecated;\n', '    /// @notice The address of a transfer proxy for ERC20 tokens.\n', '    ERC20TransferProxy public erc20TransferProxy;\n', '    /// @notice The address of a state contract, which counts the amount of selled tokens.\n', '    ExchangeStateV1 public state;\n', '    /// @notice The address of a orders holder contract, which can contain unsigned orders.\n', '    ExchangeOrdersHolderV1 public ordersHolder;\n', '\n', '    /// @notice Contract constructor.\n', '    /// @param _transferProxy - The address of a deployed TransferProxy contract.\n', '    /// @param _transferProxyForDeprecated - The address of a deployed TransferProxyForDeprecated contract.\n', '    /// @param _erc20TransferProxy - The address of a deployed ERC20TransferProxy contract.\n', '    /// @param _state - The address of a deployed ExchangeStateV1 contract.\n', '    /// @param _ordersHolder - The address of a deployed ExchangeOrdersHolderV1 contract.\n', '    /// @param _beneficiary - The address wich will receive collected fees.\n', "    /// @param _buyerFeeSigner - The address to sign buyer's fees for orders.\n", '    constructor(\n', '        TransferProxy _transferProxy, TransferProxyForDeprecated _transferProxyForDeprecated, ERC20TransferProxy _erc20TransferProxy, ExchangeStateV1 _state,\n', '        ExchangeOrdersHolderV1 _ordersHolder, address payable _beneficiary, address _buyerFeeSigner\n', '    ) public {\n', '        transferProxy = _transferProxy;\n', '        transferProxyForDeprecated = _transferProxyForDeprecated;\n', '        erc20TransferProxy = _erc20TransferProxy;\n', '        state = _state;\n', '        ordersHolder = _ordersHolder;\n', '        beneficiary = _beneficiary;\n', '        buyerFeeSigner = _buyerFeeSigner;\n', '    }\n', '\n', '    /// @notice This function is called by contract owner and sets fee receiver address.\n', '    /// @param newBeneficiary - new address, who where all the fees will be transfered\n', '    function setBeneficiary(address payable newBeneficiary) external onlyOwner {\n', '        beneficiary = newBeneficiary;\n', '    }\n', '\n', '    /// @notice This function is called by contract owner and sets fee signer address.\n', "    /// @param newBuyerFeeSigner - new address, which will sign buyer's fees for orders\n", '    function setBuyerFeeSigner(address newBuyerFeeSigner) external onlyOwner {\n', '        buyerFeeSigner = newBuyerFeeSigner;\n', '    }\n', '\n', '    /// @notice This function is called to execute the exchange.\n', "    /// @notice ERC20, ERC721 or ERC1155 tokens from buyer's or seller's side must be approved for this contract before calling this function.\n", '    /// @notice To pay with ETH, transaction must send ether within the calling transaction.\n', "    /// @notice Buyer's payment value is calculated as `order.buying * amount / order.selling + buyerFee%`.\n", '    /// @dev Emits Buy event.\n', '    /// @param order - Order struct (see ExchangeDomainV1).\n', '    /// @param sig - Signed order message. To generate the message call `prepareMessage` function.\n', '    ///        Message must be prefixed with: `"\\x19Ethereum Signed Message:\\n" + message.length`.\n', '    ///        For example, web3.accounts.sign will automatically prefix the message.\n', '    ///        Also, the signature might be all zeroes, if specified order record was added to the ordersHolder.\n', "    /// @param buyerFee - Amount for buyer's fee. Represented as percents * 100 (100% => 10000. 1% => 100).\n", '    /// @param buyerFeeSig - Signed order + buyerFee message. To generate the message call prepareBuyerFeeMessage function.\n', '    ///        Message must be prefixed with: `"\\x19Ethereum Signed Message:\\n" + message.length`.\n', '    ///        For example, web3.accounts.sign will automatically prefix the message.\n', '    /// @param amount - Amount of tokens to buy.\n', "    /// @param buyer - The buyer's address.\n", '    function exchange(\n', '        Order calldata order,\n', '        Sig calldata sig,\n', '        uint buyerFee,\n', '        Sig calldata buyerFeeSig,\n', '        uint amount,\n', '        address buyer\n', '    ) payable external {\n', '        validateOrderSig(order, sig);\n', '        validateBuyerFeeSig(order, buyerFee, buyerFeeSig);\n', '        uint paying = order.buying.mul(amount).div(order.selling);\n', '        verifyOpenAndModifyOrderState(order.key, order.selling, amount);\n', '        require(order.key.sellAsset.assetType != AssetType.ETH, "ETH is not supported on sell side");\n', '        if (order.key.buyAsset.assetType == AssetType.ETH) {\n', '            validateEthTransfer(paying, buyerFee);\n', '        }\n', '        FeeSide feeSide = getFeeSide(order.key.sellAsset.assetType, order.key.buyAsset.assetType);\n', '        if (buyer == address(0x0)) {\n', '            buyer = msg.sender;\n', '        }\n', '        transferWithFeesPossibility(order.key.sellAsset, amount, order.key.owner, buyer, feeSide == FeeSide.SELL, buyerFee, order.sellerFee, order.key.buyAsset);\n', '        transferWithFeesPossibility(order.key.buyAsset, paying, msg.sender, order.key.owner, feeSide == FeeSide.BUY, order.sellerFee, buyerFee, order.key.sellAsset);\n', '        emitBuy(order, amount, buyer);\n', '    }\n', '\n', '    function validateEthTransfer(uint value, uint buyerFee) internal view {\n', '        uint256 buyerFeeValue = value.bp(buyerFee);\n', '        require(msg.value == value + buyerFeeValue, "msg.value is incorrect");\n', '    }\n', '\n', '    /// @notice Cancel the token exchange order. Can be called only by the order owner.\n', '    ///         The function makes all exchnage calls for this order revert with error.\n', '    /// @param key - The OrderKey struct of the order.\n', '    function cancel(OrderKey calldata key) external {\n', '        require(key.owner == msg.sender, "not an owner");\n', '        state.setCompleted(key, UINT256_MAX);\n', '        emit Cancel(key.sellAsset.token, key.sellAsset.tokenId, msg.sender, key.buyAsset.token, key.buyAsset.tokenId, key.salt);\n', '    }\n', '\n', '    function validateOrderSig(\n', '        Order memory order,\n', '        Sig memory sig\n', '    ) internal view {\n', '        if (sig.v == 0 && sig.r == bytes32(0x0) && sig.s == bytes32(0x0)) {\n', '            require(ordersHolder.exists(order), "incorrect signature");\n', '        } else {\n', '            require(prepareMessage(order).recover(sig.v, sig.r, sig.s) == order.key.owner, "incorrect signature");\n', '        }\n', '    }\n', '\n', '    function validateBuyerFeeSig(\n', '        Order memory order,\n', '        uint buyerFee,\n', '        Sig memory sig\n', '    ) internal view {\n', '        require(prepareBuyerFeeMessage(order, buyerFee).recover(sig.v, sig.r, sig.s) == buyerFeeSigner, "incorrect buyer fee signature");\n', '    }\n', '\n', '    /// @notice This function generates fee message to sign for exchange call.\n', '    /// @param order - Order struct.\n', '    /// @param fee - Fee amount.\n', '    /// @return Encoded (order, fee) message, wich should be signed by the buyerFeeSigner. Does not contain standard prefix.\n', '    function prepareBuyerFeeMessage(Order memory order, uint fee) public pure returns (string memory) {\n', '        return keccak256(abi.encode(order, fee)).toString();\n', '    }\n', '\n', '    /// @notice This function generates order message to sign for exchange call.\n', '    /// @param order - Order struct.\n', '    /// @return Encoded order message, wich should be signed by the token owner. Does not contain standard prefix.\n', '    function prepareMessage(Order memory order) public pure returns (string memory) {\n', '        return keccak256(abi.encode(order)).toString();\n', '    }\n', '\n', '    function transferWithFeesPossibility(Asset memory firstType, uint value, address from, address to, bool hasFee, uint256 sellerFee, uint256 buyerFee, Asset memory secondType) internal {\n', '        if (!hasFee) {\n', '            transfer(firstType, value, from, to);\n', '        } else {\n', '            transferWithFees(firstType, value, from, to, sellerFee, buyerFee, secondType);\n', '        }\n', '    }\n', '\n', '    function transfer(Asset memory asset, uint value, address from, address to) internal {\n', '        if (asset.assetType == AssetType.ETH) {\n', '            address payable toPayable = address(uint160(to));\n', '            toPayable.transfer(value);\n', '        } else if (asset.assetType == AssetType.ERC20) {\n', '            require(asset.tokenId == 0, "tokenId should be 0");\n', '            erc20TransferProxy.erc20safeTransferFrom(IERC20(asset.token), from, to, value);\n', '        } else if (asset.assetType == AssetType.ERC721) {\n', '            require(value == 1, "value should be 1 for ERC-721");\n', '            transferProxy.erc721safeTransferFrom(IERC721(asset.token), from, to, asset.tokenId);\n', '        } else if (asset.assetType == AssetType.ERC721Deprecated) {\n', '            require(value == 1, "value should be 1 for ERC-721");\n', '            transferProxyForDeprecated.erc721TransferFrom(IERC721(asset.token), from, to, asset.tokenId);\n', '        } else {\n', '            transferProxy.erc1155safeTransferFrom(IERC1155(asset.token), from, to, asset.tokenId, value, "");\n', '        }\n', '    }\n', '\n', '    function transferWithFees(Asset memory firstType, uint value, address from, address to, uint256 sellerFee, uint256 buyerFee, Asset memory secondType) internal {\n', '        uint restValue = transferFeeToBeneficiary(firstType, from, value, sellerFee, buyerFee);\n', '        if (\n', '            secondType.assetType == AssetType.ERC1155 && IERC1155(secondType.token).supportsInterface(_INTERFACE_ID_FEES) ||\n', '            (secondType.assetType == AssetType.ERC721 || secondType.assetType == AssetType.ERC721Deprecated) && IERC721(secondType.token).supportsInterface(_INTERFACE_ID_FEES)\n', '        ) {\n', '            HasSecondarySaleFees withFees = HasSecondarySaleFees(secondType.token);\n', '            address payable[] memory recipients = withFees.getFeeRecipients(secondType.tokenId);\n', '            uint[] memory fees = withFees.getFeeBps(secondType.tokenId);\n', '            require(fees.length == recipients.length);\n', '            for (uint256 i = 0; i < fees.length; i++) {\n', '                (uint newRestValue, uint current) = subFeeInBp(restValue, value, fees[i]);\n', '                restValue = newRestValue;\n', '                transfer(firstType, current, from, recipients[i]);\n', '            }\n', '        }\n', '        address payable toPayable = address(uint160(to));\n', '        transfer(firstType, restValue, from, toPayable);\n', '    }\n', '\n', '    function transferFeeToBeneficiary(Asset memory asset, address from, uint total, uint sellerFee, uint buyerFee) internal returns (uint) {\n', '        (uint restValue, uint sellerFeeValue) = subFeeInBp(total, total, sellerFee);\n', '        uint buyerFeeValue = total.bp(buyerFee);\n', '        uint beneficiaryFee = buyerFeeValue.add(sellerFeeValue);\n', '        if (beneficiaryFee > 0) {\n', '            transfer(asset, beneficiaryFee, from, beneficiary);\n', '        }\n', '        return restValue;\n', '    }\n', '\n', '    function emitBuy(Order memory order, uint amount, address buyer) internal {\n', '        emit Buy(order.key.sellAsset.token, order.key.sellAsset.tokenId, order.selling,\n', '            order.key.owner,\n', '            order.key.buyAsset.token, order.key.buyAsset.tokenId, order.buying,\n', '            buyer,\n', '            amount,\n', '            order.key.salt\n', '        );\n', '    }\n', '\n', '    function subFeeInBp(uint value, uint total, uint feeInBp) internal pure returns (uint newValue, uint realFee) {\n', '        return subFee(value, total.bp(feeInBp));\n', '    }\n', '\n', '    function subFee(uint value, uint fee) internal pure returns (uint newValue, uint realFee) {\n', '        if (value > fee) {\n', '            newValue = value - fee;\n', '            realFee = fee;\n', '        } else {\n', '            newValue = 0;\n', '            realFee = value;\n', '        }\n', '    }\n', '\n', '    function verifyOpenAndModifyOrderState(OrderKey memory key, uint selling, uint amount) internal {\n', '        uint completed = state.getCompleted(key);\n', '        uint newCompleted = completed.add(amount);\n', '        require(newCompleted <= selling, "not enough stock of order for buying");\n', '        state.setCompleted(key, newCompleted);\n', '    }\n', '\n', '    function getFeeSide(AssetType sellType, AssetType buyType) internal pure returns (FeeSide) {\n', '        if ((sellType == AssetType.ERC721 || sellType == AssetType.ERC721Deprecated) &&\n', '            (buyType == AssetType.ERC721 || buyType == AssetType.ERC721Deprecated)) {\n', '            return FeeSide.NONE;\n', '        }\n', '        if (uint(sellType) > uint(buyType)) {\n', '            return FeeSide.BUY;\n', '        }\n', '        return FeeSide.SELL;\n', '    }\n', '}']