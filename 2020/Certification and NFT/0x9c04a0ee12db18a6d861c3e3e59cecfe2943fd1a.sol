['pragma solidity 0.5.12;\n', '// https://github.com/dapphub/ds-pause\n', 'contract DSPauseAbstract {\n', '    function setOwner(address) public;\n', '    function setAuthority(address) public;\n', '    function setDelay(uint256) public;\n', '    function plans(bytes32) public view returns (bool);\n', '    function proxy() public view returns (address);\n', '    function delay() public view returns (uint256);\n', '    function plot(address, bytes32, bytes memory, uint256) public;\n', '    function drop(address, bytes32, bytes memory, uint256) public;\n', '    function exec(address, bytes32, bytes memory, uint256) public returns (bytes memory);\n', '}\n', '\n', '// https://github.com/monolithos/dss/blob/master/src/jug.sol\n', 'contract JugAbstract {\n', '    function wards(address) public view returns (uint256);\n', '    function rely(address) external;\n', '    function deny(address) external;\n', '    function ilks(bytes32) public view returns (uint256, uint256);\n', '    function vat() public view returns (address);\n', '    function vow() public view returns (address);\n', '    function base() public view returns (address);\n', '    function init(bytes32) external;\n', '    function file(bytes32, bytes32, uint256) external;\n', '    function file(bytes32, uint256) external;\n', '    function file(bytes32, address) external;\n', '    function drip(bytes32) external returns (uint256);\n', '}\n', 'contract SpellAction {\n', '    // Provides a descriptive tag for bot consumption\n', '    // This should be modified weekly to provide a summary of the actions\n', '    string constant public description = "2020-08-24 Test Spell";\n', '\n', '    address constant public MCD_JUG             = 0xF38d987939084c68a2078Ff6FC8804a994197eBC;\n', '    // decimals & precision\n', '    uint256 constant public MILLION             = 10 ** 6;\n', '    uint256 constant public RAD                 = 10 ** 45;\n', '    function execute() external {\n', '        JugAbstract(MCD_JUG).file("base", 0);\n', '    }\n', '}\n', 'contract TestSpell {\n', '    DSPauseAbstract  public pause =\n', '        DSPauseAbstract(0xD4A71B333607549386aDCf528bAd2D096122F31c);\n', '    address          public action;\n', '    bytes32          public tag;\n', '    uint256          public eta;\n', '    bytes            public sig;\n', '    uint256          public expiration;\n', '    bool             public done;\n', '    constructor() public {\n', '        sig = abi.encodeWithSignature("execute()");\n', '        action = address(new SpellAction());\n', '        bytes32 _tag;\n', '        address _action = action;\n', '        assembly { _tag := extcodehash(_action) }\n', '        tag = _tag;\n', '        expiration = now + 30 days;\n', '    }\n', '    function description() public view returns (string memory) {\n', '        return SpellAction(action).description();\n', '    }\n', '    function schedule() public {\n', '        require(now <= expiration, "This contract has expired");\n', '        require(eta == 0, "This spell has already been scheduled");\n', '        eta = now + DSPauseAbstract(pause).delay();\n', '        pause.plot(action, tag, sig, eta);\n', '    }\n', '    function cast() public {\n', '        require(!done, "spell-already-cast");\n', '        done = true;\n', '        pause.exec(action, tag, sig, eta);\n', '    }\n', '}']