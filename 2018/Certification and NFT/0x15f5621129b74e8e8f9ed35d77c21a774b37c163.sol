['pragma solidity ^0.4.21;\n', '\n', '// File: contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/KnowYourCustomer.sol\n', '\n', 'contract KnowYourCustomer is Ownable\n', '{\n', '    //\n', '    // with this structure\n', '    //\n', '    struct Contributor {\n', '        // kyc cleared or not\n', '        bool cleared;\n', '\n', '        // % more for the contributor bring on board in 1/100 of %\n', '        // 2.51 % --> 251\n', '        // 100% --> 10000\n', '        uint16 contributor_get;\n', '\n', '        // eth address of the referer if any - the contributor address is the key of the hash\n', '        address ref;\n', '\n', '        // % more for the referrer\n', '        uint16 affiliate_get;\n', '    }\n', '\n', '\n', '    mapping (address => Contributor) public whitelist;\n', '    //address[] public whitelistArray;\n', '\n', '    /**\n', '    *    @dev Populate the whitelist, only executed by whiteListingAdmin\n', '    *  whiteListingAdmin /\n', '    */\n', '\n', '    function setContributor(address _address, bool cleared, uint16 contributor_get, uint16 affiliate_get, address ref) onlyOwner public{\n', '\n', '        // not possible to give an exorbitant bonus to be more than 100% (100x100 = 10000)\n', '        require(contributor_get<10000);\n', '        require(affiliate_get<10000);\n', '\n', '        Contributor storage contributor = whitelist[_address];\n', '\n', '        contributor.cleared = cleared;\n', '        contributor.contributor_get = contributor_get;\n', '\n', '        contributor.ref = ref;\n', '        contributor.affiliate_get = affiliate_get;\n', '\n', '    }\n', '\n', '    function getContributor(address _address) view public returns (bool, uint16, address, uint16 ) {\n', '        return (whitelist[_address].cleared, whitelist[_address].contributor_get, whitelist[_address].ref, whitelist[_address].affiliate_get);\n', '    }\n', '\n', '    function getClearance(address _address) view public returns (bool) {\n', '        return whitelist[_address].cleared;\n', '    }\n', '}']