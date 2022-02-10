['pragma solidity ^0.4.15;\n', '\n', 'contract AbstractMintableToken {\n', '    function mintFromTrustedContract(address _to, uint256 _amount) returns (bool);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract RegistrationBonus is Ownable {\n', '    address public tokenAddr;\n', '    uint256 constant  bonusAmount = 1 * 1 ether;\n', '    mapping (address => uint) public beneficiaryAddresses;\n', '    mapping (uint => address) public beneficiaryUserIds;\n', '    AbstractMintableToken token;\n', '\n', '    event BonusEnrolled(address beneficiary, uint userId, uint256 amount);\n', '\n', '    function RegistrationBonus(address _token){\n', '        tokenAddr = _token;\n', '        token = AbstractMintableToken(tokenAddr);\n', '    }\n', '\n', '    function addBonusToken(address _beneficiary, uint _userId) onlyOwner returns (bool) {\n', '        require(beneficiaryAddresses[_beneficiary] == 0);\n', '        require(beneficiaryUserIds[_userId] == 0);\n', '\n', '        if(token.mintFromTrustedContract(_beneficiary, bonusAmount)) {\n', '            beneficiaryAddresses[_beneficiary] = _userId;\n', '            beneficiaryUserIds[_userId] = _beneficiary;\n', '            BonusEnrolled(_beneficiary, _userId, bonusAmount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.15;\n', '\n', 'contract AbstractMintableToken {\n', '    function mintFromTrustedContract(address _to, uint256 _amount) returns (bool);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract RegistrationBonus is Ownable {\n', '    address public tokenAddr;\n', '    uint256 constant  bonusAmount = 1 * 1 ether;\n', '    mapping (address => uint) public beneficiaryAddresses;\n', '    mapping (uint => address) public beneficiaryUserIds;\n', '    AbstractMintableToken token;\n', '\n', '    event BonusEnrolled(address beneficiary, uint userId, uint256 amount);\n', '\n', '    function RegistrationBonus(address _token){\n', '        tokenAddr = _token;\n', '        token = AbstractMintableToken(tokenAddr);\n', '    }\n', '\n', '    function addBonusToken(address _beneficiary, uint _userId) onlyOwner returns (bool) {\n', '        require(beneficiaryAddresses[_beneficiary] == 0);\n', '        require(beneficiaryUserIds[_userId] == 0);\n', '\n', '        if(token.mintFromTrustedContract(_beneficiary, bonusAmount)) {\n', '            beneficiaryAddresses[_beneficiary] = _userId;\n', '            beneficiaryUserIds[_userId] = _beneficiary;\n', '            BonusEnrolled(_beneficiary, _userId, bonusAmount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '}']
