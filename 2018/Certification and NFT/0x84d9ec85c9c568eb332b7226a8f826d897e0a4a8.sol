['pragma solidity ^0.4.16;\n', '\n', '/// @author Bowen Sanders\n', '/// sections built on the work of Jordi Baylina (Owned, data structure)\n', '/// smartwedindex.sol contains a simple index of contract address, couple name, actual marriage date, bool displayValues to\n', '/// be used to create an array of all SmartWed contracts that are deployed \n', '/// contract 0wned is licesned under GNU-3\n', '\n', '/// @dev `Owned` is a base level contract that assigns an `owner` that can be\n', '///  later changed\n', 'contract Owned {\n', '\n', '    /// @dev `owner` is the only address that can call a function with this\n', '    /// modifier\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    address public owner;\n', '\n', '    /// @notice The Constructor assigns the message sender to be `owner`\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    address public newOwner;\n', '\n', '    /// @notice `owner` can step down and assign some other address to this role\n', '    /// @param _newOwner The address of the new owner\n', '    ///  an unowned neutral vault, however that cannot be undone\n', '    function changeOwner(address _newOwner) onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    /// @notice `newOwner` has to accept the ownership before it is transferred\n', '    ///  Any account or any contract with the ability to call `acceptOwnership`\n', '    ///  can be used to accept ownership of this contract, including a contract\n', '    ///  with no other functions\n', '    function acceptOwnership() {\n', '        if (msg.sender == newOwner) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '    // This is a general safty function that allows the owner to do a lot\n', '    //  of things in the unlikely event that something goes wrong\n', '    // _dst is the contract being called making this like a 1/1 multisig\n', '    function execute(address _dst, uint _value, bytes _data) onlyOwner {\n', '        _dst.call.value(_value)(_data);\n', '    }\n', '}\n', '\n', '// contract WedIndex \n', '\n', 'contract WedIndex is Owned {\n', '\n', '    // declare index data variables\n', '    string public wedaddress;\n', '    string public partnernames;\n', '    uint public indexdate;\n', '    uint public weddingdate;\n', '    uint public displaymultisig;\n', '\n', '    IndexArray[] public indexarray;\n', '\n', '    struct IndexArray {\n', '        uint indexdate;\n', '        string wedaddress;\n', '        string partnernames;\n', '        uint weddingdate;\n', '        uint displaymultisig;\n', '    }\n', '    \n', '    function numberOfIndex() constant public returns (uint) {\n', '        return indexarray.length;\n', '    }\n', '\n', '\n', '    // make functions to write and read index entries and nubmer of entries\n', '    function writeIndex(uint indexdate, string wedaddress, string partnernames, uint weddingdate, uint displaymultisig) {\n', '        indexarray.push(IndexArray(now, wedaddress, partnernames, weddingdate, displaymultisig));\n', '        IndexWritten(now, wedaddress, partnernames, weddingdate, displaymultisig);\n', '    }\n', '\n', '    // declare events\n', '    event IndexWritten (uint time, string contractaddress, string partners, uint weddingdate, uint display);\n', '}']