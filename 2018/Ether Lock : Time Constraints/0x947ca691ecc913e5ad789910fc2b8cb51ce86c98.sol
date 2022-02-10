['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract IcoStorage is Ownable {\n', '\n', '    struct Project {\n', '        bool isValue; // We now can know this is an initialized struct\n', '        string name; // ICO company name\n', '        address tokenAddress; // Token&#39;s smart contract address\n', '        bool active;    // if true, this contract can be shown\n', '    }\n', '\n', '    mapping(address => Project) public projects;\n', '    address[] public projectsAccts;\n', '\n', '    function createProject(\n', '        string _name,\n', '        address _icoContractAddress,\n', '        address _tokenAddress\n', '    ) public onlyOwner returns (bool) {\n', '        Project storage project  = projects[_icoContractAddress]; // Create new project\n', '\n', '        project.isValue = true; // project is initilaized and not empty\n', '        project.name = _name;\n', '        project.tokenAddress = _tokenAddress;\n', '        project.active = true;\n', '\n', '        projectsAccts.push(_icoContractAddress);\n', '\n', '        return true;\n', '    }\n', '\n', '    function getProject(address _icoContractAddress) public view returns (string, address, bool) {\n', '        require(projects[_icoContractAddress].isValue);\n', '\n', '        return (\n', '            projects[_icoContractAddress].name,\n', '            projects[_icoContractAddress].tokenAddress,\n', '            projects[_icoContractAddress].active\n', '        );\n', '    }\n', '\n', '    function activateProject(address _icoContractAddress) public onlyOwner returns (bool) {\n', '        Project storage project  = projects[_icoContractAddress];\n', '        require(project.isValue); // Check project exists\n', '\n', '        project.active = true;\n', '\n', '        return true;\n', '    }\n', '\n', '    function deactivateProject(address _icoContractAddress) public onlyOwner returns (bool) {\n', '        Project storage project  = projects[_icoContractAddress];\n', '        require(project.isValue); // Check project exists\n', '\n', '        project.active = false;\n', '\n', '        return false;\n', '    }\n', '\n', '    function getProjects() public view returns (address[]) {\n', '        return projectsAccts;\n', '    }\n', '\n', '    function countProjects() public view returns (uint256) {\n', '        return projectsAccts.length;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract IcoStorage is Ownable {\n', '\n', '    struct Project {\n', '        bool isValue; // We now can know this is an initialized struct\n', '        string name; // ICO company name\n', "        address tokenAddress; // Token's smart contract address\n", '        bool active;    // if true, this contract can be shown\n', '    }\n', '\n', '    mapping(address => Project) public projects;\n', '    address[] public projectsAccts;\n', '\n', '    function createProject(\n', '        string _name,\n', '        address _icoContractAddress,\n', '        address _tokenAddress\n', '    ) public onlyOwner returns (bool) {\n', '        Project storage project  = projects[_icoContractAddress]; // Create new project\n', '\n', '        project.isValue = true; // project is initilaized and not empty\n', '        project.name = _name;\n', '        project.tokenAddress = _tokenAddress;\n', '        project.active = true;\n', '\n', '        projectsAccts.push(_icoContractAddress);\n', '\n', '        return true;\n', '    }\n', '\n', '    function getProject(address _icoContractAddress) public view returns (string, address, bool) {\n', '        require(projects[_icoContractAddress].isValue);\n', '\n', '        return (\n', '            projects[_icoContractAddress].name,\n', '            projects[_icoContractAddress].tokenAddress,\n', '            projects[_icoContractAddress].active\n', '        );\n', '    }\n', '\n', '    function activateProject(address _icoContractAddress) public onlyOwner returns (bool) {\n', '        Project storage project  = projects[_icoContractAddress];\n', '        require(project.isValue); // Check project exists\n', '\n', '        project.active = true;\n', '\n', '        return true;\n', '    }\n', '\n', '    function deactivateProject(address _icoContractAddress) public onlyOwner returns (bool) {\n', '        Project storage project  = projects[_icoContractAddress];\n', '        require(project.isValue); // Check project exists\n', '\n', '        project.active = false;\n', '\n', '        return false;\n', '    }\n', '\n', '    function getProjects() public view returns (address[]) {\n', '        return projectsAccts;\n', '    }\n', '\n', '    function countProjects() public view returns (uint256) {\n', '        return projectsAccts.length;\n', '    }\n', '}']