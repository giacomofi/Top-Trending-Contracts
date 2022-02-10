['pragma solidity ^0.4.21;\n', '/**\n', ' * Changes by https://www.docademic.com/\n', ' */\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'contract Destroyable is Ownable{\n', '    /**\n', '     * @notice Allows to destroy the contract and return the tokens to the owner.\n', '     */\n', '    function destroy() public onlyOwner{\n', '        selfdestruct(owner);\n', '    }\n', '}\n', 'interface Token {\n', '    function transfer(address _to, uint256 _value) external;\n', '\n', '    function balanceOf(address who) view external returns (uint256);\n', '}\n', '\n', 'contract MultiVesting is Ownable, Destroyable {\n', '    using SafeMath for uint256;\n', '\n', '    // beneficiary of tokens\n', '    struct Beneficiary {\n', '        string description;\n', '        uint256 vested;\n', '        uint256 released;\n', '        uint256 start;\n', '        uint256 cliff;\n', '        uint256 duration;\n', '        bool revoked;\n', '        bool revocable;\n', '        bool isBeneficiary;\n', '    }\n', '\n', '    event Released(address _beneficiary, uint256 amount);\n', '    event Revoked(address _beneficiary);\n', '    event NewBeneficiary(address _beneficiary);\n', '    event BeneficiaryDestroyed(address _beneficiary);\n', '\n', '\n', '    mapping(address => Beneficiary) public beneficiaries;\n', '    address[] public addresses;\n', '    Token public token;\n', '    uint256 public totalVested;\n', '    uint256 public totalReleased;\n', '\n', '    /*\n', '     *  Modifiers\n', '     */\n', '    modifier isNotBeneficiary(address _beneficiary) {\n', '        require(!beneficiaries[_beneficiary].isBeneficiary);\n', '        _;\n', '    }\n', '    modifier isBeneficiary(address _beneficiary) {\n', '        require(beneficiaries[_beneficiary].isBeneficiary);\n', '        _;\n', '    }\n', '\n', '    modifier wasRevoked(address _beneficiary) {\n', '        require(beneficiaries[_beneficiary].revoked);\n', '        _;\n', '    }\n', '\n', '    modifier wasNotRevoked(address _beneficiary) {\n', '        require(!beneficiaries[_beneficiary].revoked);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Creates a vesting contract that vests its balance of any ERC20 token to the\n', '     * beneficiary, gradually in a linear fashion until _start + _duration. By then all\n', '     * of the balance will have vested.\n', '     * @param _token address of the token of vested tokens\n', '     */\n', '    function MultiVesting (address _token) public {\n', '        require(_token != address(0));\n', '        token = Token(_token);\n', '    }\n', '\n', '    function() payable public {\n', '        release(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers vested tokens to beneficiary (alternative to fallback function).\n', '     */\n', '    function release() public {\n', '        release(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers vested tokens to beneficiary.\n', '     * @param _beneficiary Beneficiary address\n', '     */\n', '    function release(address _beneficiary) private\n', '    isBeneficiary(_beneficiary)\n', '    {\n', '        Beneficiary storage beneficiary = beneficiaries[_beneficiary];\n', '\n', '        uint256 unreleased = releasableAmount(_beneficiary);\n', '\n', '        require(unreleased > 0);\n', '\n', '        beneficiary.released = beneficiary.released.add(unreleased);\n', '\n', '        totalReleased = totalReleased.add(unreleased);\n', '\n', '        token.transfer(_beneficiary, unreleased);\n', '\n', '        if ((beneficiary.vested - beneficiary.released) == 0) {\n', '            beneficiary.isBeneficiary = false;\n', '        }\n', '\n', '        emit Released(_beneficiary, unreleased);\n', '    }\n', '\n', '    /**\n', '     * @notice Allows the owner to transfers vested tokens to beneficiary.\n', '     * @param _beneficiary Beneficiary address\n', '     */\n', '    function releaseTo(address _beneficiary) public onlyOwner {\n', '        release(_beneficiary);\n', '    }\n', '\n', '    /**\n', '     * @dev Add new beneficiary to start vesting\n', '     * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '     * @param _start time in seconds which the tokens will vest\n', '     * @param _cliff time in seconds of the cliff in which tokens will begin to vest\n', '     * @param _duration duration in seconds of the period in which the tokens will vest\n', '     * @param _revocable whether the vesting is revocable or not\n', '     */\n', '    function addBeneficiary(address _beneficiary, uint256 _vested, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable, string _description)\n', '    onlyOwner\n', '    isNotBeneficiary(_beneficiary)\n', '    public {\n', '        require(_beneficiary != address(0));\n', '        require(_cliff >= _start);\n', '        require(token.balanceOf(this) >= totalVested.sub(totalReleased).add(_vested));\n', '        beneficiaries[_beneficiary] = Beneficiary({\n', '            released : 0,\n', '            vested : _vested,\n', '            start : _start,\n', '            cliff : _cliff,\n', '            duration : _duration,\n', '            revoked : false,\n', '            revocable : _revocable,\n', '            isBeneficiary : true,\n', '            description : _description\n', '            });\n', '        totalVested = totalVested.add(_vested);\n', '        addresses.push(_beneficiary);\n', '        emit NewBeneficiary(_beneficiary);\n', '    }\n', '\n', '    /**\n', '     * @notice Allows the owner to revoke the vesting. Tokens already vested\n', '     * remain in the contract, the rest are returned to the owner.\n', '     * @param _beneficiary Beneficiary address\n', '     */\n', '    function revoke(address _beneficiary) public onlyOwner {\n', '        Beneficiary storage beneficiary = beneficiaries[_beneficiary];\n', '        require(beneficiary.revocable);\n', '        require(!beneficiary.revoked);\n', '\n', '        uint256 balance = beneficiary.vested.sub(beneficiary.released);\n', '\n', '        uint256 unreleased = releasableAmount(_beneficiary);\n', '        uint256 refund = balance.sub(unreleased);\n', '\n', '        token.transfer(owner, refund);\n', '\n', '        totalReleased = totalReleased.add(refund);\n', '\n', '        beneficiary.revoked = true;\n', '        beneficiary.released = beneficiary.released.add(refund);\n', '\n', '        emit Revoked(_beneficiary);\n', '    }\n', '\n', '    /**\n', '     * @notice Allows the owner to destroy a beneficiary. Remain tokens are returned to the owner.\n', '     * @param _beneficiary Beneficiary address\n', '     */\n', '    function destroyBeneficiary(address _beneficiary) public onlyOwner {\n', '        Beneficiary storage beneficiary = beneficiaries[_beneficiary];\n', '\n', '        uint256 balance = beneficiary.vested.sub(beneficiary.released);\n', '\n', '        token.transfer(owner, balance);\n', '\n', '        totalReleased = totalReleased.add(balance);\n', '\n', '        beneficiary.isBeneficiary = false;\n', '        beneficiary.released = beneficiary.released.add(balance);\n', '\n', '        for (uint i = 0; i < addresses.length - 1; i++)\n', '            if (addresses[i] == _beneficiary) {\n', '                addresses[i] = addresses[addresses.length - 1];\n', '                break;\n', '            }\n', '\n', '        addresses.length -= 1;\n', '\n', '        emit BeneficiaryDestroyed(_beneficiary);\n', '    }\n', '\n', '    /**\n', '     * @notice Allows the owner to clear the contract. Remain tokens are returned to the owner.\n', '     */\n', '    function clearAll() public onlyOwner {\n', '\n', '        token.transfer(owner, token.balanceOf(this));\n', '\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            Beneficiary storage beneficiary = beneficiaries[addresses[i]];\n', '            beneficiary.isBeneficiary = false;\n', '            beneficiary.released = 0;\n', '            beneficiary.vested = 0;\n', '            beneficiary.start = 0;\n', '            beneficiary.cliff = 0;\n', '            beneficiary.duration = 0;\n', '            beneficiary.revoked = false;\n', '            beneficiary.revocable = false;\n', '            beneficiary.description = "";\n', '        }\n', '        addresses.length = 0;\n', '\n', '    }\n', '\n', '    /**\n', '     * @dev Calculates the amount that has already vested but hasn&#39;t been released yet.\n', '     * @param _beneficiary Beneficiary address\n', '     */\n', '    function releasableAmount(address _beneficiary) public view returns (uint256) {\n', '        return vestedAmount(_beneficiary).sub(beneficiaries[_beneficiary].released);\n', '    }\n', '\n', '    /**\n', '     * @dev Calculates the amount that has already vested.\n', '     * @param _beneficiary Beneficiary address\n', '     */\n', '    function vestedAmount(address _beneficiary) public view returns (uint256) {\n', '        Beneficiary storage beneficiary = beneficiaries[_beneficiary];\n', '        uint256 totalBalance = beneficiary.vested;\n', '\n', '        if (now < beneficiary.cliff) {\n', '            return 0;\n', '        } else if (now >= beneficiary.start.add(beneficiary.duration) || beneficiary.revoked) {\n', '            return totalBalance;\n', '        } else {\n', '            return totalBalance.mul(now.sub(beneficiary.start)).div(beneficiary.duration);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Get the remain MTC on the contract.\n', '     */\n', '    function Balance() view public returns (uint256) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '\n', '    /**\n', '     * @dev Get the numbers of beneficiaries in the vesting contract.\n', '     */\n', '    function beneficiariesLength() view public returns (uint256) {\n', '        return addresses.length;\n', '    }\n', '\n', '    /**\n', '     * @notice Allows the owner to flush the eth.\n', '     */\n', '    function flushEth() public onlyOwner {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '\n', '    /**\n', '     * @notice Allows the owner to destroy the contract and return the tokens to the owner.\n', '     */\n', '    function destroy() public onlyOwner {\n', '        token.transfer(owner, token.balanceOf(this));\n', '        selfdestruct(owner);\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '/**\n', ' * Changes by https://www.docademic.com/\n', ' */\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'contract Destroyable is Ownable{\n', '    /**\n', '     * @notice Allows to destroy the contract and return the tokens to the owner.\n', '     */\n', '    function destroy() public onlyOwner{\n', '        selfdestruct(owner);\n', '    }\n', '}\n', 'interface Token {\n', '    function transfer(address _to, uint256 _value) external;\n', '\n', '    function balanceOf(address who) view external returns (uint256);\n', '}\n', '\n', 'contract MultiVesting is Ownable, Destroyable {\n', '    using SafeMath for uint256;\n', '\n', '    // beneficiary of tokens\n', '    struct Beneficiary {\n', '        string description;\n', '        uint256 vested;\n', '        uint256 released;\n', '        uint256 start;\n', '        uint256 cliff;\n', '        uint256 duration;\n', '        bool revoked;\n', '        bool revocable;\n', '        bool isBeneficiary;\n', '    }\n', '\n', '    event Released(address _beneficiary, uint256 amount);\n', '    event Revoked(address _beneficiary);\n', '    event NewBeneficiary(address _beneficiary);\n', '    event BeneficiaryDestroyed(address _beneficiary);\n', '\n', '\n', '    mapping(address => Beneficiary) public beneficiaries;\n', '    address[] public addresses;\n', '    Token public token;\n', '    uint256 public totalVested;\n', '    uint256 public totalReleased;\n', '\n', '    /*\n', '     *  Modifiers\n', '     */\n', '    modifier isNotBeneficiary(address _beneficiary) {\n', '        require(!beneficiaries[_beneficiary].isBeneficiary);\n', '        _;\n', '    }\n', '    modifier isBeneficiary(address _beneficiary) {\n', '        require(beneficiaries[_beneficiary].isBeneficiary);\n', '        _;\n', '    }\n', '\n', '    modifier wasRevoked(address _beneficiary) {\n', '        require(beneficiaries[_beneficiary].revoked);\n', '        _;\n', '    }\n', '\n', '    modifier wasNotRevoked(address _beneficiary) {\n', '        require(!beneficiaries[_beneficiary].revoked);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Creates a vesting contract that vests its balance of any ERC20 token to the\n', '     * beneficiary, gradually in a linear fashion until _start + _duration. By then all\n', '     * of the balance will have vested.\n', '     * @param _token address of the token of vested tokens\n', '     */\n', '    function MultiVesting (address _token) public {\n', '        require(_token != address(0));\n', '        token = Token(_token);\n', '    }\n', '\n', '    function() payable public {\n', '        release(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers vested tokens to beneficiary (alternative to fallback function).\n', '     */\n', '    function release() public {\n', '        release(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers vested tokens to beneficiary.\n', '     * @param _beneficiary Beneficiary address\n', '     */\n', '    function release(address _beneficiary) private\n', '    isBeneficiary(_beneficiary)\n', '    {\n', '        Beneficiary storage beneficiary = beneficiaries[_beneficiary];\n', '\n', '        uint256 unreleased = releasableAmount(_beneficiary);\n', '\n', '        require(unreleased > 0);\n', '\n', '        beneficiary.released = beneficiary.released.add(unreleased);\n', '\n', '        totalReleased = totalReleased.add(unreleased);\n', '\n', '        token.transfer(_beneficiary, unreleased);\n', '\n', '        if ((beneficiary.vested - beneficiary.released) == 0) {\n', '            beneficiary.isBeneficiary = false;\n', '        }\n', '\n', '        emit Released(_beneficiary, unreleased);\n', '    }\n', '\n', '    /**\n', '     * @notice Allows the owner to transfers vested tokens to beneficiary.\n', '     * @param _beneficiary Beneficiary address\n', '     */\n', '    function releaseTo(address _beneficiary) public onlyOwner {\n', '        release(_beneficiary);\n', '    }\n', '\n', '    /**\n', '     * @dev Add new beneficiary to start vesting\n', '     * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '     * @param _start time in seconds which the tokens will vest\n', '     * @param _cliff time in seconds of the cliff in which tokens will begin to vest\n', '     * @param _duration duration in seconds of the period in which the tokens will vest\n', '     * @param _revocable whether the vesting is revocable or not\n', '     */\n', '    function addBeneficiary(address _beneficiary, uint256 _vested, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable, string _description)\n', '    onlyOwner\n', '    isNotBeneficiary(_beneficiary)\n', '    public {\n', '        require(_beneficiary != address(0));\n', '        require(_cliff >= _start);\n', '        require(token.balanceOf(this) >= totalVested.sub(totalReleased).add(_vested));\n', '        beneficiaries[_beneficiary] = Beneficiary({\n', '            released : 0,\n', '            vested : _vested,\n', '            start : _start,\n', '            cliff : _cliff,\n', '            duration : _duration,\n', '            revoked : false,\n', '            revocable : _revocable,\n', '            isBeneficiary : true,\n', '            description : _description\n', '            });\n', '        totalVested = totalVested.add(_vested);\n', '        addresses.push(_beneficiary);\n', '        emit NewBeneficiary(_beneficiary);\n', '    }\n', '\n', '    /**\n', '     * @notice Allows the owner to revoke the vesting. Tokens already vested\n', '     * remain in the contract, the rest are returned to the owner.\n', '     * @param _beneficiary Beneficiary address\n', '     */\n', '    function revoke(address _beneficiary) public onlyOwner {\n', '        Beneficiary storage beneficiary = beneficiaries[_beneficiary];\n', '        require(beneficiary.revocable);\n', '        require(!beneficiary.revoked);\n', '\n', '        uint256 balance = beneficiary.vested.sub(beneficiary.released);\n', '\n', '        uint256 unreleased = releasableAmount(_beneficiary);\n', '        uint256 refund = balance.sub(unreleased);\n', '\n', '        token.transfer(owner, refund);\n', '\n', '        totalReleased = totalReleased.add(refund);\n', '\n', '        beneficiary.revoked = true;\n', '        beneficiary.released = beneficiary.released.add(refund);\n', '\n', '        emit Revoked(_beneficiary);\n', '    }\n', '\n', '    /**\n', '     * @notice Allows the owner to destroy a beneficiary. Remain tokens are returned to the owner.\n', '     * @param _beneficiary Beneficiary address\n', '     */\n', '    function destroyBeneficiary(address _beneficiary) public onlyOwner {\n', '        Beneficiary storage beneficiary = beneficiaries[_beneficiary];\n', '\n', '        uint256 balance = beneficiary.vested.sub(beneficiary.released);\n', '\n', '        token.transfer(owner, balance);\n', '\n', '        totalReleased = totalReleased.add(balance);\n', '\n', '        beneficiary.isBeneficiary = false;\n', '        beneficiary.released = beneficiary.released.add(balance);\n', '\n', '        for (uint i = 0; i < addresses.length - 1; i++)\n', '            if (addresses[i] == _beneficiary) {\n', '                addresses[i] = addresses[addresses.length - 1];\n', '                break;\n', '            }\n', '\n', '        addresses.length -= 1;\n', '\n', '        emit BeneficiaryDestroyed(_beneficiary);\n', '    }\n', '\n', '    /**\n', '     * @notice Allows the owner to clear the contract. Remain tokens are returned to the owner.\n', '     */\n', '    function clearAll() public onlyOwner {\n', '\n', '        token.transfer(owner, token.balanceOf(this));\n', '\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            Beneficiary storage beneficiary = beneficiaries[addresses[i]];\n', '            beneficiary.isBeneficiary = false;\n', '            beneficiary.released = 0;\n', '            beneficiary.vested = 0;\n', '            beneficiary.start = 0;\n', '            beneficiary.cliff = 0;\n', '            beneficiary.duration = 0;\n', '            beneficiary.revoked = false;\n', '            beneficiary.revocable = false;\n', '            beneficiary.description = "";\n', '        }\n', '        addresses.length = 0;\n', '\n', '    }\n', '\n', '    /**\n', "     * @dev Calculates the amount that has already vested but hasn't been released yet.\n", '     * @param _beneficiary Beneficiary address\n', '     */\n', '    function releasableAmount(address _beneficiary) public view returns (uint256) {\n', '        return vestedAmount(_beneficiary).sub(beneficiaries[_beneficiary].released);\n', '    }\n', '\n', '    /**\n', '     * @dev Calculates the amount that has already vested.\n', '     * @param _beneficiary Beneficiary address\n', '     */\n', '    function vestedAmount(address _beneficiary) public view returns (uint256) {\n', '        Beneficiary storage beneficiary = beneficiaries[_beneficiary];\n', '        uint256 totalBalance = beneficiary.vested;\n', '\n', '        if (now < beneficiary.cliff) {\n', '            return 0;\n', '        } else if (now >= beneficiary.start.add(beneficiary.duration) || beneficiary.revoked) {\n', '            return totalBalance;\n', '        } else {\n', '            return totalBalance.mul(now.sub(beneficiary.start)).div(beneficiary.duration);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Get the remain MTC on the contract.\n', '     */\n', '    function Balance() view public returns (uint256) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '\n', '    /**\n', '     * @dev Get the numbers of beneficiaries in the vesting contract.\n', '     */\n', '    function beneficiariesLength() view public returns (uint256) {\n', '        return addresses.length;\n', '    }\n', '\n', '    /**\n', '     * @notice Allows the owner to flush the eth.\n', '     */\n', '    function flushEth() public onlyOwner {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '\n', '    /**\n', '     * @notice Allows the owner to destroy the contract and return the tokens to the owner.\n', '     */\n', '    function destroy() public onlyOwner {\n', '        token.transfer(owner, token.balanceOf(this));\n', '        selfdestruct(owner);\n', '    }\n', '}']
