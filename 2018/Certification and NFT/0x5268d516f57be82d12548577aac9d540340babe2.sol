['pragma solidity ^0.4.24;\n', '\n', '// File: contracts/interfaces/IOwned.sol\n', '\n', '/*\n', '    Owned Contract Interface\n', '*/\n', 'contract IOwned {\n', '    function transferOwnership(address _newOwner) public;\n', '    function acceptOwnership() public;\n', '    function transferOwnershipNow(address newContractOwner) public;\n', '}\n', '\n', '// File: contracts/utility/Owned.sol\n', '\n', '/*\n', '    This is the "owned" utility contract used by bancor with one additional function - transferOwnershipNow()\n', '    \n', '    The original unmodified version can be found here:\n', '    https://github.com/bancorprotocol/contracts/commit/63480ca28534830f184d3c4bf799c1f90d113846\n', '    \n', '    Provides support and utilities for contract ownership\n', '*/\n', 'contract Owned is IOwned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);\n', '\n', '    /**\n', '        @dev constructor\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // allows execution by the owner only\n', '    modifier ownerOnly {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev allows transferring the contract ownership\n', '        the new owner still needs to accept the transfer\n', '        can only be called by the contract owner\n', '        @param _newOwner    new contract owner\n', '    */\n', '    function transferOwnership(address _newOwner) public ownerOnly {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '        @dev used by a new owner to accept an ownership transfer\n', '    */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '\n', '    /**\n', '        @dev transfers the contract ownership without needing the new owner to accept ownership\n', '        @param newContractOwner    new contract owner\n', '    */\n', '    function transferOwnershipNow(address newContractOwner) ownerOnly public {\n', '        require(newContractOwner != owner);\n', '        emit OwnerUpdate(owner, newContractOwner);\n', '        owner = newContractOwner;\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/interfaces/IRegistrar.sol\n', '\n', '/*\n', '    Smart Token interface\n', '*/\n', 'contract IRegistrar is IOwned {\n', '    function addNewAddress(address _newAddress) public;\n', '    function getAddresses() public view returns (address[]);\n', '}\n', '\n', '// File: contracts/Registrar.sol\n', '\n', '/**\n', '@notice Contains a record of all previous and current address of a community; For upgradeability.\n', '*/\n', 'contract Registrar is Owned, IRegistrar {\n', '\n', '    address[] addresses;\n', '    /// @notice Adds new community logic contract address to Registrar\n', '    /// @param _newAddress Address of community logic contract to upgrade to\n', '    function addNewAddress(address _newAddress) public ownerOnly {\n', '        addresses.push(_newAddress);\n', '    }\n', '\n', '    /// @return Array of community logic contract addresses\n', '    function getAddresses() public view returns (address[]) {\n', '        return addresses;\n', '    }\n', '}']