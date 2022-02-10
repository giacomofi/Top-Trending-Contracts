['pragma solidity ^0.5.0;\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'interface BlockchainCutiesERC1155Interface\n', '{\n', '    function mintNonFungibleSingleShort(uint128 _type, address _to) external;\n', '    function mintNonFungibleSingle(uint256 _type, address _to) external;\n', '    function mintNonFungibleShort(uint128 _type, address[] calldata _to) external;\n', '    function mintNonFungible(uint256 _type, address[] calldata _to) external;\n', '    function mintFungibleSingle(uint256 _id, address _to, uint256 _quantity) external;\n', '    function mintFungible(uint256 _id, address[] calldata _to, uint256[] calldata _quantities) external;\n', '    function isNonFungible(uint256 _id) external pure returns(bool);\n', '    function ownerOf(uint256 _id) external view returns (address);\n', '    function totalSupplyNonFungible(uint256 _type) view external returns (uint256);\n', '    function totalSupplyNonFungibleShort(uint128 _type) view external returns (uint256);\n', '\n', '    /**\n', '        @notice A distinct Uniform Resource Identifier (URI) for a given token.\n', '        @dev URIs are defined in RFC 3986.\n', '        The URI may point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".\n', '        @return URI string\n', '    */\n', '    function uri(uint256 _id) external view returns (string memory);\n', '    function proxyTransfer721(address _from, address _to, uint256 _tokenId, bytes calldata _data) external;\n', '    function proxyTransfer20(address _from, address _to, uint256 _tokenId, uint256 _value) external;\n', '    /**\n', "        @notice Get the balance of an account's Tokens.\n", '        @param _owner  The address of the token holder\n', '        @param _id     ID of the Token\n', "        @return        The _owner's balance of the Token type requested\n", '     */\n', '    function balanceOf(address _owner, uint256 _id) external view returns (uint256);\n', '    /**\n', '        @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).\n', '        @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).\n', '        MUST revert if `_to` is the zero address.\n', '        MUST revert if balance of holder for token `_id` is lower than the `_value` sent.\n', '        MUST revert on any other error.\n', '        MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).\n', '        After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).\n', '        @param _from    Source address\n', '        @param _to      Target address\n', '        @param _id      ID of the token type\n', '        @param _value   Transfer amount\n', '        @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`\n', '    */\n', '    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;\n', '}\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract Operators\n', '{\n', '    mapping (address=>bool) ownerAddress;\n', '    mapping (address=>bool) operatorAddress;\n', '\n', '    constructor() public\n', '    {\n', '        ownerAddress[msg.sender] = true;\n', '    }\n', '\n', '    modifier onlyOwner()\n', '    {\n', '        require(ownerAddress[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function isOwner(address _addr) public view returns (bool) {\n', '        return ownerAddress[_addr];\n', '    }\n', '\n', '    function addOwner(address _newOwner) external onlyOwner {\n', '        require(_newOwner != address(0));\n', '\n', '        ownerAddress[_newOwner] = true;\n', '    }\n', '\n', '    function removeOwner(address _oldOwner) external onlyOwner {\n', '        delete(ownerAddress[_oldOwner]);\n', '    }\n', '\n', '    modifier onlyOperator() {\n', '        require(isOperator(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isOperator(address _addr) public view returns (bool) {\n', '        return operatorAddress[_addr] || ownerAddress[_addr];\n', '    }\n', '\n', '    function addOperator(address _newOperator) external onlyOwner {\n', '        require(_newOperator != address(0));\n', '\n', '        operatorAddress[_newOperator] = true;\n', '    }\n', '\n', '    function removeOperator(address _oldOperator) external onlyOwner {\n', '        delete(operatorAddress[_oldOperator]);\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Operators {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'interface CutieGeneratorInterface\n', '{\n', '    function generate(uint _genome, uint16 _generation, address[] calldata _target) external;\n', '    function generateSingle(uint _genome, uint16 _generation, address _target) external returns (uint40 babyId);\n', '}\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', '    Note: The ERC-165 identifier for this interface is 0x43b236a2.\n', '*/\n', 'interface IERC1155TokenReceiver {\n', '\n', '    /**\n', '        @notice Handle the receipt of a single ERC1155 token type.\n', '        @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.\n', '        This function MUST return `bytes4(keccak256("accept_erc1155_tokens()"))` (i.e. 0x4dc21a2f) if it accepts the transfer.\n', '        This function MUST revert if it rejects the transfer.\n', '        Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.\n', '        @param _operator  The address which initiated the transfer (i.e. msg.sender)\n', '        @param _from      The address which previously owned the token\n', '        @param _id        The id of the token being transferred\n', '        @param _value     The amount of tokens being transferred\n', '        @param _data      Additional data with no specified format\n', '        @return           `bytes4(keccak256("accept_erc1155_tokens()"))`\n', '    */\n', '    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4);\n', '\n', '    /**\n', '        @notice Handle the receipt of multiple ERC1155 token types.\n', '        @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.\n', '        This function MUST return `bytes4(keccak256("accept_batch_erc1155_tokens()"))` (i.e. 0xac007889) if it accepts the transfer(s).\n', '        This function MUST revert if it rejects the transfer(s).\n', '        Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.\n', '        @param _operator  The address which initiated the batch transfer (i.e. msg.sender)\n', '        @param _from      The address which previously owned the token\n', '        @param _ids       An array containing ids of each token being transferred (order and length must match _values array)\n', '        @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)\n', '        @param _data      Additional data with no specified format\n', '        @return           `bytes4(keccak256("accept_batch_erc1155_tokens()"))`\n', '    */\n', '    function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4);\n', '\n', '    /**\n', '        @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.\n', '        @dev This function MUST return `bytes4(keccak256("isERC1155TokenReceiver()"))` (i.e. 0x0d912442).\n', '        This function MUST NOT consume more than 5,000 gas.\n', '        @return           `bytes4(keccak256("isERC1155TokenReceiver()"))`\n', '    */\n', '    function isERC1155TokenReceiver() external view returns (bytes4);\n', '}\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20 {\n', '\n', '    function balanceOf(address tokenOwner) external view returns (uint balance);\n', '    function transfer(address to, uint tokens) external returns (bool success);\n', '}\n', '\n', '\n', '/// @title BlockchainCuties Presale\n', '/// @author https://BlockChainArchitect.io\n', 'contract Sale is Pausable, IERC1155TokenReceiver\n', '{\n', '    struct RewardToken1155\n', '    {\n', '        uint tokenId;\n', '        uint count;\n', '    }\n', '\n', '    struct RewardNFT\n', '    {\n', '        uint128 nftKind;\n', '        uint128 tokenIndex;\n', '    }\n', '\n', '    struct RewardCutie\n', '    {\n', '        uint genome;\n', '        uint16 generation;\n', '    }\n', '\n', '    uint32 constant RATE_SIGN = 0;\n', '    uint32 constant NATIVE = 1;\n', '\n', '    struct Lot\n', '    {\n', '        RewardToken1155[] rewardsToken1155; // stackable\n', '        uint128[] rewardsNftMint; // stackable\n', '        RewardNFT[] rewardsNftFixed; // non stackable - one element per lot\n', '        RewardCutie[] rewardsCutie; // stackable\n', '        uint128 price;\n', '        uint128 leftCount;\n', '        uint128 priceMul;\n', '        uint128 priceAdd;\n', '        uint32 expireTime;\n', '        uint32 lotKind;\n', '    }\n', '\n', '    mapping (uint32 => Lot) public lots;\n', '\n', '    BlockchainCutiesERC1155Interface public token1155;\n', '    CutieGeneratorInterface public cutieGenerator;\n', '    address public signerAddress;\n', '\n', '    event Bid(address indexed purchaser, uint32 indexed lotId, uint value, address indexed token);\n', '    event LotChange(uint32 indexed lotId);\n', '\n', '    function setToken1155(BlockchainCutiesERC1155Interface _token1155) onlyOwner external\n', '    {\n', '        token1155 = _token1155;\n', '    }\n', '\n', '    function setCutieGenerator(CutieGeneratorInterface _cutieGenerator) onlyOwner external\n', '    {\n', '        cutieGenerator = _cutieGenerator;\n', '    }\n', '\n', '    function setLot(uint32 lotId, uint128 price, uint128 count, uint32 expireTime, uint128 priceMul, uint128 priceAdd, uint32 lotKind) external onlyOperator\n', '    {\n', '        Lot storage lot = lots[lotId];\n', '        lot.price = price;\n', '        lot.leftCount = count;\n', '        lot.expireTime = expireTime;\n', '        lot.priceMul = priceMul;\n', '        lot.priceAdd = priceAdd;\n', '        lot.lotKind = lotKind;\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function setLotLeftCount(uint32 lotId, uint128 count) external onlyOperator\n', '    {\n', '        Lot storage lot = lots[lotId];\n', '        lot.leftCount = count;\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function setExpireTime(uint32 lotId, uint32 expireTime) external onlyOperator\n', '    {\n', '        Lot storage lot = lots[lotId];\n', '        lot.expireTime = expireTime;\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function setPrice(uint32 lotId, uint128 price) external onlyOperator\n', '    {\n', '        lots[lotId].price = price;\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function deleteLot(uint32 lotId) external onlyOperator\n', '    {\n', '        delete lots[lotId];\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function addRewardToken1155(uint32 lotId, uint tokenId, uint count) external onlyOperator\n', '    {\n', '        lots[lotId].rewardsToken1155.push(RewardToken1155(tokenId, count));\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function setRewardToken1155(uint32 lotId, uint tokenId, uint count) external onlyOwner\n', '    {\n', '        delete lots[lotId].rewardsToken1155;\n', '        lots[lotId].rewardsToken1155.push(RewardToken1155(tokenId, count));\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function setRewardNftFixed(uint32 lotId, uint128 nftType, uint128 tokenIndex) external onlyOperator\n', '    {\n', '        delete lots[lotId].rewardsNftFixed;\n', '        lots[lotId].rewardsNftFixed.push(RewardNFT(nftType, tokenIndex));\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function addRewardNftFixed(uint32 lotId, uint128 nftType, uint128 tokenIndex) external onlyOperator\n', '    {\n', '        lots[lotId].rewardsNftFixed.push(RewardNFT(nftType, tokenIndex));\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function addRewardNftFixedBulk(uint32 lotId, uint128 nftType, uint128[] calldata tokenIndex) external onlyOperator\n', '    {\n', '        for (uint i = 0; i < tokenIndex.length; i++)\n', '        {\n', '            lots[lotId].rewardsNftFixed.push(RewardNFT(nftType, tokenIndex[i]));\n', '        }\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function addRewardNftMint(uint32 lotId, uint128 nftType) external onlyOperator\n', '    {\n', '        lots[lotId].rewardsNftMint.push(nftType);\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function setRewardNftMint(uint32 lotId, uint128 nftType) external onlyOperator\n', '    {\n', '        delete lots[lotId].rewardsNftMint;\n', '        lots[lotId].rewardsNftMint.push(nftType);\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function addRewardCutie(uint32 lotId, uint genome, uint16 generation) external onlyOperator\n', '    {\n', '        lots[lotId].rewardsCutie.push(RewardCutie(genome, generation));\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function setRewardCutie(uint32 lotId, uint genome, uint16 generation) external onlyOperator\n', '    {\n', '        delete lots[lotId].rewardsCutie;\n', '        lots[lotId].rewardsCutie.push(RewardCutie(genome, generation));\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function isAvailable(uint32 lotId) public view returns (bool)\n', '    {\n', '        Lot storage lot = lots[lotId];\n', '        return\n', '            lot.leftCount > 0 && lot.expireTime >= now;\n', '    }\n', '\n', '    function getLot(uint32 lotId) external view returns (\n', '        uint256 price,\n', '        uint256 left,\n', '        uint256 expireTime,\n', '        uint256 lotKind\n', '    )\n', '    {\n', '        Lot storage p = lots[lotId];\n', '        price = p.price;\n', '        left = p.leftCount;\n', '        expireTime = p.expireTime;\n', '        lotKind = p.lotKind;\n', '    }\n', '\n', '    function getLotRewards(uint32 lotId) external view returns (\n', '            uint256 price,\n', '            uint256 left,\n', '            uint256 expireTime,\n', '            uint128 priceMul,\n', '            uint128 priceAdd,\n', '            uint256[5] memory rewardsToken1155tokenId,\n', '            uint256[5] memory rewardsToken1155count,\n', '            uint256[5] memory rewardsNFTMintNftKind,\n', '            uint256[5] memory rewardsNFTFixedKind,\n', '            uint256[5] memory rewardsNFTFixedIndex,\n', '            uint256[5] memory rewardsCutieGenome,\n', '            uint256[5] memory rewardsCutieGeneration\n', '        )\n', '    {\n', '        Lot storage p = lots[lotId];\n', '        price = p.price;\n', '        left = p.leftCount;\n', '        expireTime = p.expireTime;\n', '        priceAdd = p.priceAdd;\n', '        priceMul = p.priceMul;\n', '        uint i;\n', '        for (i = 0; i < p.rewardsToken1155.length; i++)\n', '        {\n', '            rewardsToken1155tokenId[i] = p.rewardsToken1155[i].tokenId;\n', '            rewardsToken1155count[i] = p.rewardsToken1155[i].count;\n', '        }\n', '        for (i = 0; i < p.rewardsNftMint.length; i++)\n', '        {\n', '            rewardsNFTMintNftKind[i] = p.rewardsNftMint[i];\n', '        }\n', '        for (i = 0; i < p.rewardsNftFixed.length; i++)\n', '        {\n', '            rewardsNFTFixedKind[i] = p.rewardsNftFixed[i].nftKind;\n', '            rewardsNFTFixedIndex[i] = p.rewardsNftFixed[i].tokenIndex;\n', '        }\n', '        for (i = 0; i < p.rewardsCutie.length; i++)\n', '        {\n', '            rewardsCutieGenome[i] = p.rewardsCutie[i].genome;\n', '            rewardsCutieGeneration[i] = p.rewardsCutie[i].generation;\n', '        }\n', '    }\n', '\n', '    function deleteRewards(uint32 lotId) external onlyOwner\n', '    {\n', '        delete lots[lotId].rewardsToken1155;\n', '        delete lots[lotId].rewardsNftMint;\n', '        delete lots[lotId].rewardsNftFixed;\n', '        delete lots[lotId].rewardsCutie;\n', '        emit LotChange(lotId);\n', '    }\n', '\n', '    function bidWithPlugin(uint32 lotId, uint valueForEvent, address tokenForEvent) external payable onlyOperator\n', '    {\n', '        _bid(lotId, valueForEvent, tokenForEvent);\n', '    }\n', '\n', '    function _bid(uint32 lotId, uint valueForEvent, address tokenForEvent) internal whenNotPaused\n', '    {\n', '        Lot storage p = lots[lotId];\n', '        require(isAvailable(lotId), "Lot is not available");\n', '\n', '        emit Bid(msg.sender, lotId, valueForEvent, tokenForEvent);\n', '\n', '        p.leftCount--;\n', '        p.price += uint128(uint256(p.price)*p.priceMul / 1000000);\n', '        p.price += p.priceAdd;\n', '        uint i;\n', '        for (i = 0; i < p.rewardsToken1155.length; i++)\n', '        {\n', '            mintToken1155(msg.sender, p.rewardsToken1155[i]);\n', '        }\n', '        if (p.rewardsNftFixed.length > 0)\n', '        {\n', '            transferNFT(msg.sender, p.rewardsNftFixed[p.rewardsNftFixed.length-1]);\n', '            p.rewardsNftFixed.length--;\n', '        }\n', '        for (i = 0; i < p.rewardsNftMint.length; i++)\n', '        {\n', '            mintNFT(msg.sender, p.rewardsNftMint[i]);\n', '        }\n', '        for (i = 0; i < p.rewardsCutie.length; i++)\n', '        {\n', '            mintCutie(msg.sender, p.rewardsCutie[i]);\n', '        }\n', '    }\n', '\n', '    function mintToken1155(address purchaser, RewardToken1155 storage reward) internal\n', '    {\n', '        token1155.mintFungibleSingle(reward.tokenId, purchaser, reward.count);\n', '    }\n', '\n', '    function mintNFT(address purchaser, uint128 nftKind) internal\n', '    {\n', '        token1155.mintNonFungibleSingleShort(nftKind, purchaser);\n', '    }\n', '\n', '    function transferNFT(address purchaser, RewardNFT storage reward) internal\n', '    {\n', '        uint tokenId = (uint256(reward.nftKind) << 128) | (1 << 255) | reward.tokenIndex;\n', '        token1155.safeTransferFrom(address(this), purchaser, tokenId, 1, "");\n', '    }\n', '\n', '    function mintCutie(address purchaser, RewardCutie storage reward) internal\n', '    {\n', '        cutieGenerator.generateSingle(reward.genome, reward.generation, purchaser);\n', '    }\n', '\n', '    function destroyContract() external onlyOwner {\n', '        require(address(this).balance == 0);\n', '        selfdestruct(msg.sender);\n', '    }\n', '\n', '    /// @dev Reject all Ether\n', '    function() external payable {\n', '        revert();\n', '    }\n', '\n', '    /// @dev The balance transfer to project owners\n', '    function withdrawEthFromBalance(uint value) external onlyOwner\n', '    {\n', '        uint256 total = address(this).balance;\n', '        if (total > value)\n', '        {\n', '            total = value;\n', '        }\n', '\n', '        msg.sender.transfer(total);\n', '    }\n', '\n', '    function bidNative(uint32 lotId) external payable\n', '    {\n', '        Lot storage lot = lots[lotId];\n', '        require(lot.price <= msg.value, "Not enough value provided");\n', '        require(lot.lotKind == NATIVE, "Lot kind should be NATIVE");\n', '\n', '        _bid(lotId, msg.value, address(0x0));\n', '    }\n', '\n', '    function bid(uint32 lotId, uint rate, uint expireAt, uint8 _v, bytes32 _r, bytes32 _s) external payable\n', '    {\n', '        Lot storage lot = lots[lotId];\n', '        require(lot.lotKind == RATE_SIGN, "Lot kind should be RATE_SIGN");\n', '\n', '        require(isValidSignature(rate, expireAt, _v, _r, _s));\n', '        require(expireAt >= now, "Rate sign is expired");\n', '\n', '\n', '        uint priceInWei = rate * lot.price;\n', '        require(priceInWei <= msg.value, "Not enough value provided");\n', '\n', '        _bid(lotId, priceInWei, address(0x0));\n', '    }\n', '\n', '    function setSigner(address _newSigner) public onlyOwner {\n', '        signerAddress = _newSigner;\n', '    }\n', '\n', '    function isValidSignature(uint rate, uint expireAt, uint8 _v, bytes32 _r, bytes32 _s) public view returns (bool)\n', '    {\n', '        return getSigner(rate, expireAt, _v, _r, _s) == signerAddress;\n', '    }\n', '\n', '    function getSigner(uint rate, uint expireAt, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address)\n', '    {\n', '        bytes32 msgHash = hashArguments(rate, expireAt);\n', '        return ecrecover(msgHash, _v, _r, _s);\n', '    }\n', '\n', '    /// @dev Common function to be used also in backend\n', '    function hashArguments(uint rate, uint expireAt) public pure returns (bytes32 msgHash)\n', '    {\n', '        msgHash = keccak256(abi.encode(rate, expireAt));\n', '    }\n', '\n', '    function withdrawERC20FromBalance(ERC20 _tokenContract) external onlyOwner\n', '    {\n', '        uint256 balance = _tokenContract.balanceOf(address(this));\n', '        _tokenContract.transfer(msg.sender, balance);\n', '    }\n', '\n', '    function withdrawERC1155FromBalance(BlockchainCutiesERC1155Interface _tokenContract, uint tokenId) external onlyOwner\n', '    {\n', '        uint256 balance = _tokenContract.balanceOf(address(this), tokenId);\n', '        _tokenContract.safeTransferFrom(address(this), msg.sender, tokenId, balance, "");\n', '    }\n', '\n', '    function isERC1155TokenReceiver() external view returns (bytes4) {\n', '        return bytes4(keccak256("isERC1155TokenReceiver()"));\n', '    }\n', '\n', '    function onERC1155BatchReceived(address, address, uint256[] calldata, uint256[] calldata, bytes calldata) external returns(bytes4)\n', '    {\n', '        return bytes4(keccak256("acrequcept_batch_erc1155_tokens()"));\n', '    }\n', '\n', '    function onERC1155Received(address, address, uint256, uint256, bytes calldata) external returns(bytes4)\n', '    {\n', '        return bytes4(keccak256("accept_erc1155_tokens()"));\n', '    }\n', '}']