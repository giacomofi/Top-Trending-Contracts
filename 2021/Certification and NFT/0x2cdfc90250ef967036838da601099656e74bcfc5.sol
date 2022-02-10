['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'import "Ownable.sol";\n', 'import "ZeroCopySink.sol";\n', 'import "ZeroCopySource.sol";\n', 'import "Utils.sol";\n', 'import "Address.sol";\n', 'import "IERC721Metadata.sol";\n', 'import "IERC721Receiver.sol";\n', 'import "SafeMath.sol";\n', 'import "IEthCrossChainManager.sol";\n', 'import "IEthCrossChainManagerProxy.sol";\n', '\n', 'contract PolyNFTLockProxy is IERC721Receiver, Ownable {\n', '    using SafeMath for uint;\n', '    using Address for address;\n', '\n', '    struct TxArgs {\n', '        bytes toAssetHash;\n', '        bytes toAddress;\n', '        uint256 tokenId;\n', '        bytes tokenURI;\n', '    }\n', '\n', '    address public managerProxyContract;\n', '    mapping(uint64 => bytes) public proxyHashMap;\n', '    mapping(address => mapping(uint64 => bytes)) public assetHashMap;\n', '    mapping(address => bool) safeTransfer;\n', '\n', '    event SetManagerProxyEvent(address manager);\n', '    event BindProxyEvent(uint64 toChainId, bytes targetProxyHash);\n', '    event BindAssetEvent(address fromAssetHash, uint64 toChainId, bytes targetProxyHash);\n', '    event UnlockEvent(address toAssetHash, address toAddress, uint256 tokenId);\n', '    event LockEvent(address fromAssetHash, address fromAddress, bytes toAssetHash, bytes toAddress, uint64 toChainId, uint256 tokenId);\n', '    \n', '    modifier onlyManagerContract() {\n', '        IEthCrossChainManagerProxy ieccmp = IEthCrossChainManagerProxy(managerProxyContract);\n', '        require(_msgSender() == ieccmp.getEthCrossChainManager(), "msgSender is not EthCrossChainManagerContract");\n', '        _;\n', '    }\n', '    \n', '    function setManagerProxy(address ethCCMProxyAddr) onlyOwner public {\n', '        managerProxyContract = ethCCMProxyAddr;\n', '        emit SetManagerProxyEvent(managerProxyContract);\n', '    }\n', '    \n', '    function bindProxyHash(uint64 toChainId, bytes memory targetProxyHash) onlyOwner public returns (bool) {\n', '        proxyHashMap[toChainId] = targetProxyHash;\n', '        emit BindProxyEvent(toChainId, targetProxyHash);\n', '        return true;\n', '    }\n', '    \n', '    function bindAssetHash(address fromAssetHash, uint64 toChainId, bytes memory toAssetHash) onlyOwner public returns (bool) {\n', '        assetHashMap[fromAssetHash][toChainId] = toAssetHash;\n', '        emit BindAssetEvent(fromAssetHash, toChainId, toAssetHash);\n', '        return true;\n', '    }\n', '    \n', '    // /* @notice                  This function is meant to be invoked by the ETH crosschain management contract,\n', '    // *                           then mint a certin amount of tokens to the designated address since a certain amount \n', '    // *                           was burnt from the source chain invoker.\n', '    // *  @param argsBs            The argument bytes recevied by the ethereum lock proxy contract, need to be deserialized.\n', '    // *                           based on the way of serialization in the source chain proxy contract.\n', '    // *  @param fromContractAddr  The source chain contract address\n', '    // *  @param fromChainId       The source chain id\n', '    // */\n', '    function unlock(bytes memory argsBs, bytes memory fromContractAddr, uint64 fromChainId) public onlyManagerContract returns (bool) {\n', '        TxArgs memory args = _deserializeTxArgs(argsBs);\n', '\n', '        require(fromContractAddr.length != 0, "from proxy contract address cannot be empty");\n', '        require(Utils.equalStorage(proxyHashMap[fromChainId], fromContractAddr), "From Proxy contract address error!");\n', '        \n', '        require(args.toAssetHash.length != 0, "toAssetHash cannot be empty");\n', '        address toAssetHash = Utils.bytesToAddress(args.toAssetHash);\n', '\n', '        require(args.toAddress.length != 0, "toAddress cannot be empty");\n', '        address toAddress = Utils.bytesToAddress(args.toAddress);\n', '        \n', '        bool success;\n', '        bytes memory res;\n', '        address owner;\n', '        bytes memory raw = abi.encodeWithSignature("ownerOf(uint256)", args.tokenId);\n', '        (success, res) = toAssetHash.call(raw);\n', '        if (success) {\n', '            owner = abi.decode(res, (address));\n', '            require(owner == address(this) || owner == address(0), "your token ID is not hold by lockproxy.");\n', '            if (owner == address(this)) {\n', '                raw = abi.encodeWithSignature("safeTransferFrom(address,address,uint256)", address(this), toAddress, args.tokenId);\n', '                (success, ) = toAssetHash.call(raw);\n', '                require(success, "failed to call safeTransferFrom");\n', '            }\n', '        }\n', '        if (!success || owner == address(0)) {\n', '            raw = abi.encodeWithSignature("mintWithURI(address,uint256,string)", toAddress, args.tokenId, string(args.tokenURI));\n', '            (success, ) = toAssetHash.call(raw);\n', '            require(success, "failed to call mintWithURI to mint a new mapping NFT");\n', '        }\n', '        \n', '        emit UnlockEvent(toAssetHash, toAddress, args.tokenId);\n', '        return true;\n', '    }\n', '\n', '    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) public override returns (bytes4) {\n', '        address fromAssetHash = _msgSender();\n', '        require(data.length > 0, "length of toAddress can\'t be zero. ");\n', '        require(fromAssetHash.isContract(), "caller must be a contract. ");\n', '            \n', '        bytes memory toAddress;\n', '        uint64 toChainId;\n', '        bytes memory toAssetHash;\n', '        {\n', '            (toAddress, toChainId) = _deserializeCallData(data);\n', '            toAssetHash = assetHashMap[fromAssetHash][toChainId];\n', '            require(toAssetHash.length != 0, "empty illegal toAssetHash");\n', '    \n', '            IERC721Metadata nft = IERC721Metadata(fromAssetHash);\n', '            require(nft.ownerOf(tokenId) == address(this), "wrong owner for this token ID");\n', '    \n', '            string memory uri = nft.tokenURI(tokenId);\n', '            TxArgs memory txArgs = TxArgs({\n', '                toAssetHash: toAssetHash,\n', '                toAddress: toAddress,\n', '                tokenId: tokenId,\n', '                tokenURI: bytes(uri)\n', '            });\n', '            bytes memory txData = _serializeTxArgs(txArgs);\n', '            IEthCrossChainManager eccm = IEthCrossChainManager(IEthCrossChainManagerProxy(managerProxyContract).getEthCrossChainManager());\n', '            \n', '            bytes memory toProxyHash = proxyHashMap[toChainId];\n', '            require(toProxyHash.length != 0, "empty illegal toProxyHash");\n', '            require(eccm.crossChain(toChainId, toProxyHash, "unlock", txData), "EthCrossChainManager crossChain executed error!");\n', '        }\n', '        {\n', '            emit LockEvent(fromAssetHash, from, toAssetHash, toAddress, toChainId, tokenId);\n', '        }\n', '\n', '        return this.onERC721Received.selector;\n', '    }\n', '    \n', '    function _serializeTxArgs(TxArgs memory args) internal pure returns (bytes memory) {\n', '        bytes memory buff;\n', '        buff = abi.encodePacked(\n', '            ZeroCopySink.WriteVarBytes(args.toAssetHash),\n', '            ZeroCopySink.WriteVarBytes(args.toAddress),\n', '            ZeroCopySink.WriteUint256(args.tokenId),\n', '            ZeroCopySink.WriteVarBytes(args.tokenURI)\n', '            );\n', '        return buff;\n', '    }\n', '\n', '    function _deserializeTxArgs(bytes memory valueBs) internal pure returns (TxArgs memory) {\n', '        TxArgs memory args;\n', '        uint256 off = 0;\n', '        (args.toAssetHash, off) = ZeroCopySource.NextVarBytes(valueBs, off);\n', '        (args.toAddress, off) = ZeroCopySource.NextVarBytes(valueBs, off);\n', '        (args.tokenId, off) = ZeroCopySource.NextUint256(valueBs, off);\n', '        (args.tokenURI, off) = ZeroCopySource.NextVarBytes(valueBs, off);\n', '        return args;\n', '    }\n', '    \n', '    function _deserializeCallData(bytes memory valueBs) internal pure returns (bytes memory, uint64) {\n', '        bytes memory toAddress;\n', '        uint64 chainId;\n', '        uint256 off = 0;\n', '        (toAddress, off) = ZeroCopySource.NextVarBytes(valueBs, off);\n', '        (chainId, off) = ZeroCopySource.NextUint64(valueBs, off);\n', '        return (toAddress, chainId);\n', '    }\n', '}']