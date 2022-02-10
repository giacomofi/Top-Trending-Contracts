['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-16\n', '*/\n', '\n', '// File: contracts/upgradeability/Proxy.sol\n', '\n', 'pragma solidity 0.7.5;\n', '\n', '/**\n', ' * @title Proxy\n', ' * @dev Gives the possibility to delegate any call to a foreign implementation.\n', ' */\n', 'abstract contract Proxy {\n', '    /**\n', '     * @dev Tells the address of the implementation where every call will be delegated.\n', '     * @return address of the implementation to which it will be delegated\n', '     */\n', '    function implementation() public view virtual returns (address);\n', '\n', '    /**\n', '     * @dev Fallback function allowing to perform a delegatecall to the given implementation.\n', '     * This function will return whatever the implementation call returns\n', '     */\n', '    fallback() external payable {\n', '        // solhint-disable-previous-line no-complex-fallback\n', '        address _impl = implementation();\n', '        require(_impl != address(0));\n', '        assembly {\n', '            /*\n', '                0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)\n', '                loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty\n', "                memory. It's needed because we're going to write the return data of delegatecall to the\n", '                free memory slot.\n', '            */\n', '            let ptr := mload(0x40)\n', '            /*\n', '                `calldatacopy` is copy calldatasize bytes from calldata\n', '                First argument is the destination to which data is copied(ptr)\n', '                Second argument specifies the start position of the copied data.\n', '                    Since calldata is sort of its own unique location in memory,\n', "                    0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.\n", "                    That's always going to be the zeroth byte of the function selector.\n", '                Third argument, calldatasize, specifies how much data will be copied.\n', '                    calldata is naturally calldatasize bytes long (same thing as msg.data.length)\n', '            */\n', '            calldatacopy(ptr, 0, calldatasize())\n', '            /*\n', '                delegatecall params explained:\n', '                gas: the amount of gas to provide for the call. `gas` is an Opcode that gives\n', '                    us the amount of gas still available to execution\n', '\n', '                _impl: address of the contract to delegate to\n', '\n', '                ptr: to pass copied data\n', '\n', '                calldatasize: loads the size of `bytes memory data`, same as msg.data.length\n', '\n', '                0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,\n', '                        these are set to 0, 0 so the output data will not be written to memory. The output\n', '                        data will be read using `returndatasize` and `returdatacopy` instead.\n', '\n', '                result: This will be 0 if the call fails and 1 if it succeeds\n', '            */\n', '            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)\n', '            /*\n', '\n', '            */\n', '            /*\n', '                ptr current points to the value stored at 0x40,\n', '                because we assigned it like ptr := mload(0x40).\n', '                Because we use 0x40 as a free memory pointer,\n', '                we want to make sure that the next time we want to allocate memory,\n', "                we aren't overwriting anything important.\n", '                So, by adding ptr and returndatasize,\n', '                we get a memory location beyond the end of the data we will be copying to ptr.\n', '                We place this in at 0x40, and any reads from 0x40 will now read from free memory\n', '            */\n', '            mstore(0x40, add(ptr, returndatasize()))\n', '            /*\n', '                `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the\n', '                    slot it will copy to, 0 means copy from the beginning of the return data, and size is\n', '                    the amount of data to copy.\n', '                `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall\n', '            */\n', '            returndatacopy(ptr, 0, returndatasize())\n', '\n', '            /*\n', '                if `result` is 0, revert.\n', '                if `result` is 1, return `size` amount of data from `ptr`. This is the data that was\n', '                copied to `ptr` from the delegatecall return data\n', '            */\n', '            switch result\n', '                case 0 {\n', '                    revert(ptr, returndatasize())\n', '                }\n', '                default {\n', '                    return(ptr, returndatasize())\n', '                }\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/upgradeable_contracts/modules/factory/TokenProxy.sol\n', '\n', 'pragma solidity 0.7.5;\n', '\n', '\n', 'interface IPermittableTokenVersion {\n', '    function version() external pure returns (string memory);\n', '}\n', '\n', '/**\n', ' * @title TokenProxy\n', ' * @dev Helps to reduces the size of the deployed bytecode for automatically created tokens, by using a proxy contract.\n', ' */\n', 'contract TokenProxy is Proxy {\n', '    // storage layout is copied from PermittableToken.sol\n', '    string internal name;\n', '    string internal symbol;\n', '    uint8 internal decimals;\n', '    mapping(address => uint256) internal balances;\n', '    uint256 internal totalSupply;\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '    address internal owner;\n', '    bool internal mintingFinished;\n', '    address internal bridgeContractAddr;\n', '    // string public constant version = "1";\n', '    bytes32 internal DOMAIN_SEPARATOR;\n', '    // bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;\n', '    mapping(address => uint256) internal nonces;\n', '    mapping(address => mapping(address => uint256)) internal expirations;\n', '\n', '    /**\n', '     * @dev Creates a non-upgradeable token proxy for PermitableToken.sol, initializes its eternalStorage.\n', '     * @param _tokenImage address of the token image used for mirroring all functions.\n', '     * @param _name token name.\n', '     * @param _symbol token symbol.\n', '     * @param _decimals token decimals.\n', '     * @param _chainId chain id for current network.\n', '     * @param _owner address of the owner for this contract.\n', '     */\n', '    constructor(\n', '        address _tokenImage,\n', '        string memory _name,\n', '        string memory _symbol,\n', '        uint8 _decimals,\n', '        uint256 _chainId,\n', '        address _owner\n', '    ) {\n', '        string memory version = IPermittableTokenVersion(_tokenImage).version();\n', '\n', '        assembly {\n', '            // EIP 1967\n', "            // bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)\n", '            sstore(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc, _tokenImage)\n', '        }\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        owner = _owner; // _owner == HomeOmnibridge/ForeignOmnibridge mediator\n', '        bridgeContractAddr = _owner;\n', '        DOMAIN_SEPARATOR = keccak256(\n', '            abi.encode(\n', '                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),\n', '                keccak256(bytes(_name)),\n', '                keccak256(bytes(version)),\n', '                _chainId,\n', '                address(this)\n', '            )\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Retrieves the implementation contract address, mirrored token image.\n', '     * @return impl token image address.\n', '     */\n', '    function implementation() public view override returns (address impl) {\n', '        assembly {\n', '            impl := sload(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc)\n', '        }\n', '    }\n', '}']