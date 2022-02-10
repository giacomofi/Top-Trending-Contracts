['contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract SmsCertifier is Ownable {\n', '\tevent Confirmed(address indexed who);\n', '\tevent Revoked(address indexed who);\n', '\tmodifier only_certified(address _who) { require(certs[_who].active); _; }\n', '\tmodifier only_delegate(address _who) { require(delegate[_who].active); _; }\n', '\n', '\tmapping (address => Certification) certs;\n', '\tmapping (address => Certifier) delegate;\n', '\n', '\tstruct Certification {\n', '\t\tbool active;\n', '\t\tmapping (string => bytes32) meta;\n', '\t}\n', '\n', '\tstruct Certifier {\n', '\t\tbool active;\n', '\t\tmapping (string => bytes32) meta;\n', '\t}\n', '\n', '\tfunction addDelegate(address _delegate, bytes32 _who) public onlyOwner {\n', '\t\tdelegate[_delegate].active = true;\n', "\t\tdelegate[_delegate].meta['who'] = _who;\n", '\t}\n', '\n', '\tfunction removeDelegate(address _delegate) public onlyOwner {\n', '\t\tdelegate[_delegate].active = false;\n', '\t}\n', '\n', '\tfunction certify(address _who) only_delegate(msg.sender) {\n', '\t\tcerts[_who].active = true;\n', '\t\temit Confirmed(_who);\n', '\t}\n', '\tfunction revoke(address _who) only_delegate(msg.sender) only_certified(_who) {\n', '\t\tcerts[_who].active = false;\n', '\t\temit Revoked(_who);\n', '\t}\n', '\n', '\tfunction isDelegate(address _who) public view returns (bool) { return delegate[_who].active; }\n', '\tfunction certified(address _who) public  view returns (bool) { return certs[_who].active; }\n', '\tfunction get(address _who, string _field) public view returns (bytes32) { return certs[_who].meta[_field]; }\n', '\tfunction getAddress(address _who, string _field) public view returns (address) { return address(certs[_who].meta[_field]); }\n', '\tfunction getUint(address _who, string _field) public view returns (uint) { return uint(certs[_who].meta[_field]); }\n', '\n', '}']