['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens\n', '/// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)\n', 'contract ERC721 {\n', '    // Required methods\n', '    function totalSupply() public view returns (uint256 total);\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function ownerOf(uint256 _tokenId) external view returns (address owner);\n', '    function approve(address _to, uint256 _tokenId) external;\n', '    function transfer(address _to, uint256 _tokenId) external;\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) external;\n', '    // Events\n', '    event Transfer(address from, address to, uint256 tokenId);\n', '    event Approval(address owner, address approved, uint256 tokenId);\n', '\n', '    // Optional\n', '    // function name() public view returns (string name);\n', '    // function symbol() public view returns (string symbol);\n', '    // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);\n', '    // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);\n', '    // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)\n', '    function supportsInterface(bytes4 _interfaceID) external view returns (bool);\n', '}\n', '\n', '\n', '\n', '  \n', '\n', '\n', '\n', 'contract Exchange is Ownable {\n', '\n', '    \n', '    //between 0-10000\n', '    //Default 0\n', '    uint256 public transFeeCut =  0;\n', '\n', '    enum Errors {\n', '        ORDER_EXPIRED,\n', '        ORDER_FILLED,\n', '        ORDER_CACELD,\n', '        INSUFFICIENT_BALANCE_OR_ALLOWANCE\n', '    }\n', '\n', '\n', '    struct Order {\n', '        address maker; //买方\n', '        address taker;//卖方\n', '        address contractAddr; //买房商品合约地址\n', '        uint256 nftTokenId;//买房商品ID\n', '        uint256 tokenAmount;//价格\n', '        uint expirationTimestampInSec; //到期时间\n', '        bytes32 orderHash;\n', '    }\n', '\n', '    event LogFill(\n', '        address indexed maker,\n', '        address taker,\n', '        address contractAddr,\n', '        uint256 nftTokenId,\n', '        uint tokenAmount,\n', '        bytes32 indexed tokens, // keccak256(makerToken, takerToken), allows subscribing to a token pair\n', '        bytes32 orderHash\n', '    );\n', '\n', '    event LogError(uint8 indexed errorId, bytes32 indexed orderHash);\n', '\n', '    function getOrderHash(address[3] orderAddresses, uint[4] orderValues)\n', '        public\n', '        constant\n', '        returns (bytes32)\n', '    {\n', '        return keccak256(\n', '            address(this),\n', '            orderAddresses[0], // maker\n', '            orderAddresses[1], // taker\n', '            orderAddresses[2], // contractAddr\n', '            orderValues[0],    // nftTokenId\n', '            orderValues[1],    // tokenAmount\n', '            orderValues[2],    // expirationTimestampInSec\n', '            orderValues[3]    // salt\n', '        );\n', '    }\n', '\n', '\n', '\n', '    function isValidSignature(\n', '        address signer,\n', '        bytes32 hash,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s)\n', '        public\n', '        pure\n', '        returns (bool)\n', '    {\n', '        return signer == ecrecover(\n', '            keccak256("\\x19Ethereum Signed Message:\\n32", hash),\n', '            v,\n', '            r,\n', '            s\n', '        );\n', '    }\n', '\n', '\n', '\n', '    function fillOrder(\n', '          address[3] orderAddresses,\n', '          uint[4] orderValues,\n', '          uint8 v,\n', '          bytes32 r,\n', '          bytes32 s)\n', '          public\n', '          payable\n', '    {\n', '\n', '        Order memory order = Order({\n', '            maker: orderAddresses[0],\n', '            taker: orderAddresses[1],\n', '            contractAddr: orderAddresses[2],\n', '            nftTokenId: orderValues[0],\n', '            tokenAmount : orderValues[1],\n', '            expirationTimestampInSec: orderValues[2],\n', '            orderHash: getOrderHash(orderAddresses, orderValues)\n', '        });\n', '\n', '\n', '        if (msg.value < order.tokenAmount) {\n', '            LogError(uint8(Errors.INSUFFICIENT_BALANCE_OR_ALLOWANCE), order.orderHash);\n', '            return ;\n', '        }\n', '\n', '\n', '        require(msg.value >= order.tokenAmount);\n', '        require(order.taker == address(0) || order.taker == msg.sender);\n', '\n', '\n', '        require(order.tokenAmount > 0 );\n', '        require(isValidSignature(\n', '            order.maker,\n', '            order.orderHash,\n', '            v,\n', '            r,\n', '            s\n', '        ));\n', '\n', '        if (block.timestamp >= order.expirationTimestampInSec) {\n', '            LogError(uint8(Errors.ORDER_EXPIRED), order.orderHash);\n', '            return ;\n', '        }\n', '\n', '\n', '        require( transferViaProxy ( order.contractAddr , order.maker,msg.sender , order.nftTokenId )  );\n', '\n', '        uint256 transCut = _computeCut(order.tokenAmount);\n', '        order.maker.transfer(order.tokenAmount - transCut);\n', '        uint256 bidExcess = msg.value - order.tokenAmount;\n', '        //return\n', '        msg.sender.transfer(bidExcess);\n', '        LogFill(order.maker,msg.sender,order.contractAddr,order.nftTokenId,order.tokenAmount, keccak256(order.contractAddr),order.orderHash );\n', '    }\n', '\n', '\n', '    function transferViaProxy( address nftAddr, address maker ,address taker , uint256 nftId ) internal returns(bool) \n', '    {\n', '    \n', '       ERC721(nftAddr).transferFrom( maker, taker , nftId ) ;\n', '       return true;\n', '    }\n', '\n', '    function withdrawBalance() external onlyOwner{\n', '        uint256 balance = this.balance;\n', '        owner.transfer(balance);\n', '    }\n', '\n', '    function setTransFeeCut(uint256 val) external onlyOwner {\n', '        require(val <= 10000);\n', '        transFeeCut = val;\n', '    }\n', '\n', '    function _computeCut(uint256 _price) internal view returns (uint256) {\n', '        return _price * transFeeCut / 10000;\n', '    }\n', '\n', '}']