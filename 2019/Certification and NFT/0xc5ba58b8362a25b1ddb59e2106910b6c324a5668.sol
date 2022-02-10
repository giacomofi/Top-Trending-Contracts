['/*\n', ' * Crypto stamp On-Chain Shop\n', ' * Selling NFTs directly and handling shipping of connected physical assets\n', ' *\n', ' * Developed by capacity.at\n', ' * for post.at\n', ' */\n', '\n', '// File: openzeppelin-solidity\\contracts\\token\\ERC721\\IERC721Receiver.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title ERC721 token receiver interface\n', ' * @dev Interface for any contract that wants to support safeTransfers\n', ' * from ERC721 asset contracts.\n', ' */\n', 'contract IERC721Receiver {\n', '    /**\n', '     * @notice Handle the receipt of an NFT\n', '     * @dev The ERC721 smart contract calls this function on the recipient\n', '     * after a `safeTransfer`. This function MUST return the function selector,\n', '     * otherwise the caller will revert the transaction. The selector to be\n', '     * returned can be obtained as `this.onERC721Received.selector`. This\n', '     * function MAY throw to revert and reject the transfer.\n', '     * Note: the ERC721 contract address is always the message sender.\n', '     * @param operator The address which called `safeTransferFrom` function\n', '     * @param from The address which previously owned the token\n', '     * @param tokenId The NFT identifier which is being transferred\n', '     * @param data Additional data with no specified format\n', '     * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`\n', '     */\n', '    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)\n', '    public returns (bytes4);\n', '}\n', '\n', '// File: node_modules\\openzeppelin-solidity\\contracts\\introspection\\IERC165.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title IERC165\n', ' * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @notice Query if a contract implements an interface\n', '     * @param interfaceId The interface identifier, as specified in ERC-165\n', '     * @dev Interface identification is specified in ERC-165. This function\n', '     * uses less than 30,000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '// File: node_modules\\openzeppelin-solidity\\contracts\\token\\ERC721\\IERC721.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title ERC721 Non-Fungible Token Standard basic interface\n', ' * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md\n', ' */\n', 'contract IERC721 is IERC165 {\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    function balanceOf(address owner) public view returns (uint256 balance);\n', '    function ownerOf(uint256 tokenId) public view returns (address owner);\n', '\n', '    function approve(address to, uint256 tokenId) public;\n', '    function getApproved(uint256 tokenId) public view returns (address operator);\n', '\n', '    function setApprovalForAll(address operator, bool _approved) public;\n', '    function isApprovedForAll(address owner, address operator) public view returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 tokenId) public;\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) public;\n', '\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;\n', '}\n', '\n', '// File: node_modules\\openzeppelin-solidity\\contracts\\token\\ERC721\\IERC721Enumerable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension\n', ' * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md\n', ' */\n', 'contract IERC721Enumerable is IERC721 {\n', '    function totalSupply() public view returns (uint256);\n', '    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);\n', '\n', '    function tokenByIndex(uint256 index) public view returns (uint256);\n', '}\n', '\n', '// File: node_modules\\openzeppelin-solidity\\contracts\\token\\ERC721\\IERC721Metadata.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title ERC-721 Non-Fungible Token Standard, optional metadata extension\n', ' * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md\n', ' */\n', 'contract IERC721Metadata is IERC721 {\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function tokenURI(uint256 tokenId) external view returns (string memory);\n', '}\n', '\n', '// File: openzeppelin-solidity\\contracts\\token\\ERC721\\IERC721Full.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC-721 Non-Fungible Token Standard, full implementation interface\n', ' * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md\n', ' */\n', 'contract IERC721Full is IERC721, IERC721Enumerable, IERC721Metadata {\n', '    // solhint-disable-previous-line no-empty-blocks\n', '}\n', '\n', '// File: openzeppelin-solidity\\contracts\\token\\ERC20\\IERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity\\contracts\\math\\SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts\\OracleRequest.sol\n', '\n', '/*\n', 'Interface for requests to the rate oracle (for EUR/ETH)\n', 'Copy this to projects that need to access the oracle.\n', 'See rate-oracle project for implementation.\n', '*/\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'contract OracleRequest {\n', '\n', '    uint256 public EUR_WEI; //number of wei per EUR\n', '\n', '    uint256 public lastUpdate; //timestamp of when the last update occurred\n', '\n', '    function ETH_EUR() public view returns (uint256); //number of EUR per ETH (rounded down!)\n', '\n', '    function ETH_EURCENT() public view returns (uint256); //number of EUR cent per ETH (rounded down!)\n', '\n', '}\n', '\n', '// File: contracts\\PricingStrategy.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'contract PricingStrategy {\n', '\n', '    function adjustPrice(uint256 oldprice, uint256 remainingPieces) public view returns (uint256); //returns the new price\n', '\n', '}\n', '\n', '// File: contracts\\Last100PricingStrategy.sol\n', '\n', '/*\n', '\n', '*/\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', 'contract Last100PricingStrategy is PricingStrategy {\n', '\n', '    /**\n', '    calculates a new price based on the old price and other params referenced\n', '    */\n', '    function adjustPrice(uint256 _oldPrice, uint256 _remainingPieces) public view returns (uint256){\n', '        if (_remainingPieces < 100) {\n', '            return _oldPrice * 110 / 100;\n', '        } else {\n', '            return _oldPrice;\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts\\OnChainShop.sol\n', '\n', '/*\n', 'Implements an on-chain shop for crypto stamp\n', '*/\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract OnChainShop is IERC721Receiver {\n', '    using SafeMath for uint256;\n', '\n', '    IERC721Full internal cryptostamp;\n', '    OracleRequest internal oracle;\n', '    PricingStrategy internal pricingStrategy;\n', '\n', '    address payable public beneficiary;\n', '    address public shippingControl;\n', '    address public tokenAssignmentControl;\n', '\n', '    uint256 public priceEurCent;\n', '\n', '    bool internal _isOpen = true;\n', '\n', '    enum Status{\n', '        Initial,\n', '        Sold,\n', '        ShippingSubmitted,\n', '        ShippingConfirmed\n', '    }\n', '\n', '    event AssetSold(address indexed buyer, uint256 indexed tokenId, uint256 priceWei);\n', '    event ShippingSubmitted(address indexed owner, uint256 indexed tokenId, string deliveryInfo);\n', '    event ShippingFailed(address indexed owner, uint256 indexed tokenId, string reason);\n', '    event ShippingConfirmed(address indexed owner, uint256 indexed tokenId);\n', '\n', '    mapping(uint256 => Status) public deliveryStatus;\n', '\n', '    constructor(OracleRequest _oracle,\n', '        uint256 _priceEurCent,\n', '        address payable _beneficiary,\n', '        address _shippingControl,\n', '        address _tokenAssignmentControl)\n', '    public\n', '    {\n', '        oracle = _oracle;\n', '        require(address(oracle) != address(0x0), "You need to provide an actual Oracle contract.");\n', '        beneficiary = _beneficiary;\n', '        require(address(beneficiary) != address(0x0), "You need to provide an actual beneficiary address.");\n', '        tokenAssignmentControl = _tokenAssignmentControl;\n', '        require(address(tokenAssignmentControl) != address(0x0), "You need to provide an actual tokenAssignmentControl address.");\n', '        shippingControl = _shippingControl;\n', '        require(address(shippingControl) != address(0x0), "You need to provide an actual shippingControl address.");\n', '        priceEurCent = _priceEurCent;\n', '        require(priceEurCent > 0, "You need to provide a non-zero price.");\n', '        pricingStrategy = new Last100PricingStrategy();\n', '    }\n', '\n', '    modifier onlyBeneficiary() {\n', '        require(msg.sender == beneficiary, "Only the current benefinicary can call this function.");\n', '        _;\n', '    }\n', '\n', '    modifier onlyTokenAssignmentControl() {\n', '        require(msg.sender == tokenAssignmentControl, "tokenAssignmentControl key required for this function.");\n', '        _;\n', '    }\n', '\n', '    modifier onlyShippingControl() {\n', '        require(msg.sender == shippingControl, "shippingControl key required for this function.");\n', '        _;\n', '    }\n', '\n', '    modifier requireOpen() {\n', '        require(isOpen() == true, "This call only works when the shop is open.");\n', '        _;\n', '    }\n', '\n', '    modifier requireCryptostamp() {\n', '        require(address(cryptostamp) != address(0x0), "You need to provide an actual Cryptostamp contract.");\n', '        _;\n', '    }\n', '\n', '    /*** Enable adjusting variables after deployment ***/\n', '\n', '    function setCryptostamp(IERC721Full _newCryptostamp)\n', '    public\n', '    onlyBeneficiary\n', '    {\n', '        require(address(_newCryptostamp) != address(0x0), "You need to provide an actual Cryptostamp contract.");\n', '        cryptostamp = _newCryptostamp;\n', '    }\n', '\n', '    function setPrice(uint256 _newPriceEurCent)\n', '    public\n', '    onlyBeneficiary\n', '    {\n', '        require(_newPriceEurCent > 0, "You need to provide a non-zero price.");\n', '        priceEurCent = _newPriceEurCent;\n', '    }\n', '\n', '    function setBeneficiary(address payable _newBeneficiary)\n', '    public\n', '    onlyBeneficiary\n', '    {\n', '        beneficiary = _newBeneficiary;\n', '    }\n', '\n', '    function setOracle(OracleRequest _newOracle)\n', '    public\n', '    onlyBeneficiary\n', '    {\n', '        require(address(_newOracle) != address(0x0), "You need to provide an actual Oracle contract.");\n', '        oracle = _newOracle;\n', '    }\n', '\n', '    function setPricingStrategy(PricingStrategy _newPricingStrategy)\n', '    public\n', '    onlyBeneficiary\n', '    {\n', '        require(address(_newPricingStrategy) != address(0x0), "You need to provide an actual PricingStrategy contract.");\n', '        pricingStrategy = _newPricingStrategy;\n', '    }\n', '\n', '    function openShop()\n', '    public\n', '    onlyBeneficiary\n', '    requireCryptostamp\n', '    {\n', '        _isOpen = true;\n', '    }\n', '\n', '    function closeShop()\n', '    public\n', '    onlyBeneficiary\n', '    {\n', '        _isOpen = false;\n', '    }\n', '\n', '    /*** Actual shopping functionality ***/\n', '\n', '    // return true if shop is currently open for purchases.\n', '    function isOpen()\n', '    public view\n', '    requireCryptostamp\n', '    returns (bool)\n', '    {\n', '        return _isOpen;\n', '    }\n', '\n', '    // Calculate current asset price in wei.\n', '    // Note: Price in EUR cent is available from public var getter priceEurCent().\n', '    function priceWei()\n', '    public view\n', '    returns (uint256)\n', '    {\n', '        return priceEurCent.mul(oracle.EUR_WEI()).div(100);\n', '    }\n', '\n', '    // For buying a single asset, just send enough ether to this contract.\n', '    function()\n', '    external payable\n', '    requireOpen\n', '    {\n', '        //get from eurocents to wei\n', '        uint256 curPriceWei = priceWei();\n', '        //update the price according to the strategy for the following buyer.\n', '        uint256 remaining = cryptostamp.balanceOf(address(this));\n', '        priceEurCent = pricingStrategy.adjustPrice(priceEurCent, remaining);\n', '\n', '        require(msg.value >= curPriceWei, "You need to send enough currency to actually pay the item.");\n', '        // Transfer the actual price to the beneficiary\n', '        beneficiary.transfer(curPriceWei);\n', '        // Find the next stamp and transfer it.\n', '        uint256 tokenId = cryptostamp.tokenOfOwnerByIndex(address(this), 0);\n', '        cryptostamp.safeTransferFrom(address(this), msg.sender, tokenId);\n', '        emit AssetSold(msg.sender, tokenId, curPriceWei);\n', '        deliveryStatus[tokenId] = Status.Sold;\n', '\n', '        /*send back change money. last */\n', '        if (msg.value > curPriceWei) {\n', '            msg.sender.transfer(msg.value.sub(curPriceWei));\n', '        }\n', '    }\n', '\n', '    /*** Handle physical shipping ***/\n', '\n', '    // For token owner (after successful purchase): Request shipping.\n', '    // _deliveryInfo is a postal address encrypted with a public key on the client side.\n', '    function shipToMe(string memory _deliveryInfo, uint256 _tokenId)\n', '    public\n', '    requireOpen\n', '    {\n', '        require(cryptostamp.ownerOf(_tokenId) == msg.sender, "You can only request shipping for your own tokens.");\n', '        require(deliveryStatus[_tokenId] == Status.Sold, "Shipping was already requested for this token or it was not sold by this shop.");\n', '        emit ShippingSubmitted(msg.sender, _tokenId, _deliveryInfo);\n', '        deliveryStatus[_tokenId] = Status.ShippingSubmitted;\n', '    }\n', '\n', '    // For shipping service: Mark shipping as completed/confirmed.\n', '    function confirmShipping(uint256 _tokenId)\n', '    public\n', '    onlyShippingControl\n', '    requireCryptostamp\n', '    {\n', '        deliveryStatus[_tokenId] = Status.ShippingConfirmed;\n', '        emit ShippingConfirmed(cryptostamp.ownerOf(_tokenId), _tokenId);\n', '    }\n', '\n', '    // For shipping service: Mark shipping as failed/rejected (due to invalid address).\n', '    function rejectShipping(uint256 _tokenId, string memory _reason)\n', '    public\n', '    onlyShippingControl\n', '    requireCryptostamp\n', '    {\n', '        deliveryStatus[_tokenId] = Status.Sold;\n', '        emit ShippingFailed(cryptostamp.ownerOf(_tokenId), _tokenId, _reason);\n', '    }\n', '\n', "    /*** Make sure currency or NFT doesn't get stranded in this contract ***/\n", '\n', '    // Override ERC721Receiver to special-case receiving ERC721 tokens:\n', '    // We will prevent accepting a cryptostamp from others,\n', '    // so we can make sure that we only sell physically shippable items.\n', '    // We make an exception for "beneficiary", in case we decide to increase its stock in the future.\n', '    // Also, comment out all params that are in the interface but not actually used, to quiet compiler warnings.\n', '    function onERC721Received(address /*_operator*/, address _from, uint256 /*_tokenId*/, bytes memory /*_data*/)\n', '    public\n', '    requireCryptostamp\n', '    returns (bytes4)\n', '    {\n', '        require(_from == beneficiary, "Only the current benefinicary can send assets to the shop.");\n', '        return this.onERC721Received.selector;\n', '    }\n', '\n', "    // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.\n", '    function rescueToken(IERC20 _foreignToken, address _to)\n', '    external\n', '    onlyTokenAssignmentControl\n', '    {\n', '        _foreignToken.transfer(_to, _foreignToken.balanceOf(address(this)));\n', '    }\n', '}']