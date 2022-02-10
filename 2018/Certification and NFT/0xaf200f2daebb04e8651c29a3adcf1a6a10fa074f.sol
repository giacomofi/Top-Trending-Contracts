['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath128 {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint128 a, uint128 b) internal pure returns (uint128 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint128 a, uint128 b) internal pure returns (uint128) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint128 a, uint128 b) internal pure returns (uint128) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint128 a, uint128 b) internal pure returns (uint128 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath64 {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint64 a, uint64 b) internal pure returns (uint64 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint64 a, uint64 b) internal pure returns (uint64 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath32 {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint32 a, uint32 b) internal pure returns (uint32 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint32 a, uint32 b) internal pure returns (uint32 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath16 {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint16 a, uint16 b) internal pure returns (uint16 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint16 a, uint16 b) internal pure returns (uint16 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath8 {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint8 a, uint8 b) internal pure returns (uint8 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint8 a, uint8 b) internal pure returns (uint8) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint8 a, uint8 b) internal pure returns (uint8) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint8 a, uint8 b) internal pure returns (uint8 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * Utility library of inline functions on addresses\n', ' */\n', 'library AddressUtils {\n', '\n', '    /**\n', '     * Returns whether the target address is a contract\n', '     * @dev This function will return false if invoked during the constructor of a contract,\n', '     *  as the code is not actually created until after the constructor finishes.\n', '     * @param addr address to check\n', '     * @return whether the target address is a contract\n', '     */\n', '    function isContract(address addr) internal view returns (bool) {\n', '        uint256 size;\n', '        // XXX Currently there is no better way to check if there is a contract in an address\n', '        // than to check the size of the code at that address.\n', '        // See https://ethereum.stackexchange.com/a/14016/36603\n', '        // for more details about how this works.\n', '        // TODO Check this again before the Serenity release, because all addresses will be\n', '        // contracts then.\n', '        assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly\n', '        return size > 0;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Eliptic curve signature operations\n', ' *\n', ' * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d\n', ' *\n', ' * TODO Remove this library once solidity supports passing a signature to ecrecover.\n', ' * See https://github.com/ethereum/solidity/issues/864\n', ' *\n', ' */\n', '\n', 'library ECRecovery {\n', '\n', '    /**\n', '     * @dev Recover signer address from a message by using their signature\n', '     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.\n', '     * @param sig bytes signature, the signature is generated using web3.eth.sign()\n', '     */\n', '    function recover(bytes32 hash, bytes sig) internal pure returns (address) {\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '\n', '        //Check the signature length\n', '        if (sig.length != 65) {\n', '            return (address(0));\n', '        }\n', '\n', '        // Divide the signature in r, s and v variables\n', '        // ecrecover takes the signature parameters, and the only way to get them\n', '        // currently is to use assembly.\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            r := mload(add(sig, 32))\n', '            s := mload(add(sig, 64))\n', '            v := byte(0, mload(add(sig, 96)))\n', '        }\n', '\n', '        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '        if (v < 27) {\n', '            v += 27;\n', '        }\n', '\n', '        // If the version is correct return the signer address\n', '        if (v != 27 && v != 28) {\n', '            return (address(0));\n', '        } else {\n', '            return ecrecover(hash, v, r, s);\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract MintibleUtility is Ownable {\n', '    using SafeMath     for uint256;\n', '    using SafeMath128  for uint128;\n', '    using SafeMath64   for uint64;\n', '    using SafeMath32   for uint32;\n', '    using SafeMath16   for uint16;\n', '    using SafeMath8    for uint8;\n', '    using AddressUtils for address;\n', '    using ECRecovery   for bytes32;\n', '\n', '    uint256 private nonce;\n', '\n', '    bool public paused;\n', '\n', '    modifier notPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /*\n', '     * @dev Uses binary search to find the index of the off given\n', '     */\n', '    function getIndexFromOdd(uint32 _odd, uint32[] _odds) internal pure returns (uint) {\n', '        uint256 low = 0;\n', '        uint256 high = _odds.length.sub(1);\n', '\n', '        while (low < high) {\n', '            uint256 mid = (low.add(high)) / 2;\n', '            if (_odd >= _odds[mid]) {\n', '                low = mid.add(1);\n', '            } else {\n', '                high = mid;\n', '            }\n', '        }\n', '\n', '        return low;\n', '    }\n', '\n', '    /*\n', '     * Using the `nonce` and a range, it generates a random value using `keccak256` and random distribution\n', '     */\n', '    function rand(uint32 min, uint32 max) internal returns (uint32) {\n', '        nonce++;\n', '        return uint32(keccak256(abi.encodePacked(nonce, uint(blockhash(block.number.sub(1)))))) % (min.add(max)).sub(min);\n', '    }\n', '\n', '\n', '    /*\n', '     *  Sub array utility functions\n', '     */\n', '\n', '    function getUintSubArray(uint256[] _arr, uint256 _start, uint256 _end) internal pure returns (uint256[]) {\n', '        uint256[] memory ret = new uint256[](_end.sub(_start));\n', '        for (uint256 i = _start; i < _end; i++) {\n', '            ret[i - _start] = _arr[i];\n', '        }\n', '\n', '        return ret;\n', '    }\n', '\n', '    function getUint32SubArray(uint256[] _arr, uint256 _start, uint256 _end) internal pure returns (uint32[]) {\n', '        uint32[] memory ret = new uint32[](_end.sub(_start));\n', '        for (uint256 i = _start; i < _end; i++) {\n', '            ret[i - _start] = uint32(_arr[i]);\n', '        }\n', '\n', '        return ret;\n', '    }\n', '\n', '    function getUint64SubArray(uint256[] _arr, uint256 _start, uint256 _end) internal pure returns (uint64[]) {\n', '        uint64[] memory ret = new uint64[](_end.sub(_start));\n', '        for (uint256 i = _start; i < _end; i++) {\n', '            ret[i - _start] = uint64(_arr[i]);\n', '        }\n', '\n', '        return ret;\n', '    }\n', '}\n', '\n', 'contract ERC721 {\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);\n', '    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);\n', '    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 _balance);\n', '    function ownerOf(uint256 _tokenId) public view returns (address _owner);\n', '    function exists(uint256 _tokenId) public view returns (bool _exists);\n', '\n', '    function approve(address _to, uint256 _tokenId) public;\n', '    function getApproved(uint256 _tokenId) public view returns (address _operator);\n', '\n', '    function setApprovalForAll(address _operator, bool _approved) public;\n', '    function isApprovedForAll(address _owner, address _operator) public view returns (bool);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;\n', '    function safeTransferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _tokenId,\n', '        bytes _data\n', '    )\n', '    public;\n', '}\n', '\n', '/*\n', ' * An interface extension of ERC721\n', ' */\n', 'contract MintibleI is ERC721 {\n', '    function getLastModifiedNonce(uint256 _id) public view returns (uint);\n', '    function payFee(uint256 _id) public payable;\n', '}\n', '\n', '/**\n', ' * This contract assumes that it was approved beforehand\n', ' */\n', 'contract MintibleMarketplace is MintibleUtility {\n', '\n', '    event EtherOffer(address from, address to, address contractAddress, uint256 id, uint256 price);\n', '    event InvalidateSignature(bytes signature);\n', '\n', '    mapping(bytes32 => bool) public consumed;\n', '    mapping(address => bool) public implementsMintibleInterface;\n', '\n', '    /*\n', '     * @dev Function that verifies that `_contractAddress` implements the `MintibleI`\n', '     */\n', '    function setImplementsMintibleInterface(address _contractAddress) public notPaused {\n', '        require(isPayFeeSafe(_contractAddress) && isGetLastModifiedNonceSafe(_contractAddress));\n', '\n', '        implementsMintibleInterface[_contractAddress] = true;\n', '    }\n', '\n', '    /*\n', '     * @dev This function consumes a signature to buy an item for ether\n', '     */\n', '    function consumeEtherOffer(\n', '        address _from,\n', '        address _contractAddress,\n', '        uint256 _id,\n', '        uint256 _expiryBlock,\n', '        uint128 _uuid,\n', '        bytes   _signature\n', '    ) public payable notPaused {\n', '\n', '        uint itemNonce;\n', '\n', '        if (implementsMintibleInterface[_contractAddress]) {\n', '            itemNonce = MintibleI(_contractAddress).getLastModifiedNonce(_id);\n', '        }\n', '\n', '        bytes32 hash = keccak256(abi.encodePacked(address(this), _contractAddress, _id, msg.value, _expiryBlock, _uuid, itemNonce));\n', '\n', "        // Ensure this hash wasn't already consumed\n", '        require(!consumed[hash]);\n', '        consumed[hash] = true;\n', '\n', '        validateConsumedHash(_from, hash, _signature);\n', '\n', '        // Verify the expiration date of the signature\n', '        require(block.number < _expiryBlock);\n', '\n', '        // 1% marketplace fee\n', '        uint256 marketplaceFee = msg.value.mul(10 finney) / 1 ether;\n', '        // 2.5% creator fee\n', '        uint256 creatorFee = msg.value.mul(25 finney) / 1 ether;\n', '        // How much the seller receives\n', '        uint256 amountReceived = msg.value.sub(marketplaceFee);\n', '\n', '        // Transfer token to buyer\n', '        MintibleI(_contractAddress).transferFrom(_from, msg.sender, _id);\n', '\n', '        // Increase balance of creator if contract implements MintibleI\n', '        if (implementsMintibleInterface[_contractAddress]) {\n', '            amountReceived = amountReceived.sub(creatorFee);\n', '\n', '            MintibleI(_contractAddress).payFee.value(creatorFee)(_id);\n', '        }\n', '\n', '        // Transfer funds to seller\n', '        _from.transfer(amountReceived);\n', '\n', '        emit EtherOffer(_from, msg.sender, _contractAddress, _id, msg.value);\n', '    }\n', '\n', '    // Sets a hash\n', '    function invalidateSignature(bytes32 _hash, bytes _signature) public notPaused {\n', '\n', "        bytes32 signedHash = keccak256(abi.encodePacked('\\x19Ethereum Signed Message:\\n32', _hash));\n", '        require(signedHash.recover(_signature) == msg.sender);\n', '        consumed[_hash] = true;\n', '\n', '        emit InvalidateSignature(_signature);\n', '    }\n', '\n', '    /*\n', '     * @dev Transfer `address(this).balance` to `owner`\n', '     */\n', '    function withdraw() public onlyOwner {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '\n', '    /*\n', '     * @dev This function validates that the `_hash` and `_signature` match the `_signer`\n', '     */\n', '    function validateConsumedHash(address _signer, bytes32 _hash, bytes _signature) private pure {\n', "        bytes32 signedHash = keccak256(abi.encodePacked('\\x19Ethereum Signed Message:\\n32', _hash));\n", '\n', '        // Verify signature validity\n', '        require(signedHash.recover(_signature) == _signer);\n', '    }\n', '\n', '    /*\n', '     * Function that verifies whether `payFee(uint256)` was implemented at the given address\n', '     */\n', '    function isPayFeeSafe(address _addr)\n', '        private\n', '        returns (bool _isImplemented)\n', '    {\n', '        bytes32 sig = bytes4(keccak256("payFee(uint256)"));\n', '\n', '        assembly {\n', '            let x := mload(0x40)    // get free memory\n', '            mstore(x, sig)          // store signature into it\n', '            mstore(add(x, 0x04), 1) // Send an id of 1 only for testing purposes\n', '\n', '            let _success := call(\n', '                20000,   // 20000 gas is the exact value needed for this call\n', '                _addr,  // to _addr\n', '                0,      // 0 value\n', '                x,      // input is x\n', '                0x24,   // input length is 4 + 32 bytes\n', '                x,      // store output to x\n', '                0x0     // No output\n', '            )\n', '\n', '            _isImplemented := _success\n', '        }\n', '    }\n', '\n', '    /*\n', '     * Function that verifies whether `payFee(uint256)` was implemented at the given address\n', '     */\n', '    function isGetLastModifiedNonceSafe(address _addr)\n', '        private\n', '        returns (bool _isImplemented)\n', '    {\n', '        bytes32 sig = bytes4(keccak256("getLastModifiedNonce(uint256)"));\n', '\n', '        assembly {\n', '            let x := mload(0x40)    // get free memory\n', '            mstore(x, sig)          // store signature into it\n', '            mstore(add(x, 0x04), 1) // Send an id of 1 only for testing purposes\n', '\n', '            let _success := call(\n', '                20000,  // 20000 gas is the exact value needed for this call\n', '                _addr,  // to _addr\n', '                0,      // 0 value\n', '                x,      // input is x\n', '                0x24,   // input length is 4 + 32 bytes\n', '                x,      // store output to x\n', '                0x0     // No output\n', '            )\n', '\n', '            _isImplemented := _success\n', '        }\n', '    }\n', '}']