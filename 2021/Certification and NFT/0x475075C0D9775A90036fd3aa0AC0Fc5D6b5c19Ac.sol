['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-30\n', '*/\n', '\n', '// Copyright (C) 2020 Centrifuge\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', 'pragma solidity >=0.5.15 <0.6.0;\n', '\n', '// Copyright (C) 2020 Centrifuge\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', 'pragma solidity >=0.5.15 <0.6.0;\n', '\n', 'interface ReserveFabLike {\n', '    function newReserve(address) external returns (address);\n', '}\n', '\n', 'interface AssessorFabLike {\n', '    function newAssessor() external returns (address);\n', '}\n', '\n', 'interface TrancheFabLike {\n', '    function newTranche(address, address) external returns (address);\n', '}\n', '\n', 'interface CoordinatorFabLike {\n', '    function newCoordinator(uint) external returns (address);\n', '}\n', '\n', 'interface OperatorFabLike {\n', '    function newOperator(address) external returns (address);\n', '}\n', '\n', 'interface MemberlistFabLike {\n', '    function newMemberlist() external returns (address);\n', '}\n', '\n', 'interface RestrictedTokenFabLike {\n', '    function newRestrictedToken(string calldata, string calldata) external returns (address);\n', '}\n', '\n', 'interface AssessorAdminFabLike {\n', '    function newAssessorAdmin() external returns (address);\n', '}\n', '\n', '\n', '\n', '// Copyright (C) 2020 Centrifuge\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity >=0.5.15 <0.6.0;\n', '\n', 'contract FixedPoint {\n', '    struct Fixed27 {\n', '        uint value;\n', '    }\n', '}\n', '\n', '\n', 'interface DependLike {\n', '    function depend(bytes32, address) external;\n', '}\n', '\n', 'interface AuthLike {\n', '    function rely(address) external;\n', '    function deny(address) external;\n', '}\n', '\n', 'interface MemberlistLike {\n', '    function updateMember(address, uint) external;\n', '}\n', '\n', 'interface FileLike {\n', '    function file(bytes32 name, uint value) external;\n', '}\n', '\n', 'contract LenderDeployer is FixedPoint {\n', '    address public root;\n', '    address public currency;\n', '\n', '    // factory contracts\n', '    TrancheFabLike          public trancheFab;\n', '    ReserveFabLike          public reserveFab;\n', '    AssessorFabLike         public assessorFab;\n', '    CoordinatorFabLike      public coordinatorFab;\n', '    OperatorFabLike         public operatorFab;\n', '    MemberlistFabLike       public memberlistFab;\n', '    RestrictedTokenFabLike  public restrictedTokenFab;\n', '    AssessorAdminFabLike    public assessorAdminFab;\n', '\n', '    // lender state variables\n', '    Fixed27             public minSeniorRatio;\n', '    Fixed27             public maxSeniorRatio;\n', '    uint                public maxReserve;\n', '    uint                public challengeTime;\n', '    Fixed27             public seniorInterestRate;\n', '\n', '\n', '    // contract addresses\n', '    address             public assessor;\n', '    address             public assessorAdmin;\n', '    address             public seniorTranche;\n', '    address             public juniorTranche;\n', '    address             public seniorOperator;\n', '    address             public juniorOperator;\n', '    address             public reserve;\n', '    address             public coordinator;\n', '\n', '    address             public seniorToken;\n', '    address             public juniorToken;\n', '\n', '    // token names\n', '    string              public seniorName;\n', '    string              public seniorSymbol;\n', '    string              public juniorName;\n', '    string              public juniorSymbol;\n', '    // restricted token member list\n', '    address             public seniorMemberlist;\n', '    address             public juniorMemberlist;\n', '\n', '    address             public deployer;\n', '\n', '    constructor(address root_, address currency_, address trancheFab_, address memberlistFab_, address restrictedtokenFab_, address reserveFab_, address assessorFab_, address coordinatorFab_, address operatorFab_, address assessorAdminFab_) public {\n', '\n', '        deployer = msg.sender;\n', '        root = root_;\n', '        currency = currency_;\n', '\n', '        trancheFab = TrancheFabLike(trancheFab_);\n', '        memberlistFab = MemberlistFabLike(memberlistFab_);\n', '        restrictedTokenFab = RestrictedTokenFabLike(restrictedtokenFab_);\n', '        reserveFab = ReserveFabLike(reserveFab_);\n', '        assessorFab = AssessorFabLike(assessorFab_);\n', '        assessorAdminFab = AssessorAdminFabLike(assessorAdminFab_);\n', '        coordinatorFab = CoordinatorFabLike(coordinatorFab_);\n', '        operatorFab = OperatorFabLike(operatorFab_);\n', '    }\n', '\n', '    function init(uint minSeniorRatio_, uint maxSeniorRatio_, uint maxReserve_, uint challengeTime_, uint seniorInterestRate_, string memory seniorName_, string memory seniorSymbol_, string memory juniorName_, string memory juniorSymbol_) public {\n', '        require(msg.sender == deployer);\n', '        challengeTime = challengeTime_;\n', '        minSeniorRatio = Fixed27(minSeniorRatio_);\n', '        maxSeniorRatio = Fixed27(maxSeniorRatio_);\n', '        maxReserve = maxReserve_;\n', '        seniorInterestRate = Fixed27(seniorInterestRate_);\n', '\n', '        // token names\n', '        seniorName = seniorName_;\n', '        seniorSymbol = seniorSymbol_;\n', '        juniorName = juniorName_;\n', '        juniorSymbol = juniorSymbol_;\n', '\n', '        deployer = address(1);\n', '    }\n', '\n', '    function deployJunior() public {\n', '        require(juniorTranche == address(0) && deployer == address(1));\n', '        juniorToken = restrictedTokenFab.newRestrictedToken(juniorName, juniorSymbol);\n', '        juniorTranche = trancheFab.newTranche(currency, juniorToken);\n', '        juniorMemberlist = memberlistFab.newMemberlist();\n', '        juniorOperator = operatorFab.newOperator(juniorTranche);\n', '        AuthLike(juniorMemberlist).rely(root);\n', '        AuthLike(juniorToken).rely(root);\n', '        AuthLike(juniorToken).rely(juniorTranche);\n', '        AuthLike(juniorOperator).rely(root);\n', '        AuthLike(juniorTranche).rely(root);\n', '    }\n', '\n', '    function deploySenior() public {\n', '        require(seniorTranche == address(0) && deployer == address(1));\n', '        seniorToken = restrictedTokenFab.newRestrictedToken(seniorName, seniorSymbol);\n', '        seniorTranche = trancheFab.newTranche(currency, seniorToken);\n', '        seniorMemberlist = memberlistFab.newMemberlist();\n', '        seniorOperator = operatorFab.newOperator(seniorTranche);\n', '        AuthLike(seniorMemberlist).rely(root);\n', '        AuthLike(seniorToken).rely(root);\n', '        AuthLike(seniorToken).rely(seniorTranche);\n', '        AuthLike(seniorOperator).rely(root);\n', '        AuthLike(seniorTranche).rely(root);\n', '\n', '    }\n', '\n', '    function deployReserve() public {\n', '        require(reserve == address(0) && deployer == address(1));\n', '        reserve = reserveFab.newReserve(currency);\n', '        AuthLike(reserve).rely(root);\n', '    }\n', '\n', '    function deployAssessor() public {\n', '        require(assessor == address(0) && deployer == address(1));\n', '        assessor = assessorFab.newAssessor();\n', '        AuthLike(assessor).rely(root);\n', '    }\n', '\n', '    function deployAssessorAdmin() public {\n', '        require(assessorAdmin == address(0) && deployer == address(1));\n', '        assessorAdmin = assessorAdminFab.newAssessorAdmin();\n', '        AuthLike(assessorAdmin).rely(root);\n', '    }\n', '\n', '    function deployCoordinator() public {\n', '        require(coordinator == address(0) && deployer == address(1));\n', '        coordinator = coordinatorFab.newCoordinator(challengeTime);\n', '        AuthLike(coordinator).rely(root);\n', '    }\n', '\n', '    function deploy() public {\n', '        require(coordinator != address(0) && assessor != address(0) &&\n', '                reserve != address(0) && seniorTranche != address(0));\n', '\n', '        // required depends\n', '        // reserve\n', '        DependLike(reserve).depend("assessor", assessor);\n', '        AuthLike(reserve).rely(seniorTranche);\n', '        AuthLike(reserve).rely(juniorTranche);\n', '        AuthLike(reserve).rely(coordinator);\n', '        AuthLike(reserve).rely(assessor);\n', '\n', '\n', '        // tranches\n', '        DependLike(seniorTranche).depend("reserve",reserve);\n', '        DependLike(juniorTranche).depend("reserve",reserve);\n', '        AuthLike(seniorTranche).rely(coordinator);\n', '        AuthLike(juniorTranche).rely(coordinator);\n', '        AuthLike(seniorTranche).rely(seniorOperator);\n', '        AuthLike(juniorTranche).rely(juniorOperator);\n', '\n', '        // coordinator implements epoch ticker interface\n', '        DependLike(seniorTranche).depend("epochTicker", coordinator);\n', '        DependLike(juniorTranche).depend("epochTicker", coordinator);\n', '\n', '        //restricted token\n', '        DependLike(seniorToken).depend("memberlist", seniorMemberlist);\n', '        DependLike(juniorToken).depend("memberlist", juniorMemberlist);\n', '\n', '        //allow tinlake contracts to hold drop/tin tokens\n', '        MemberlistLike(juniorMemberlist).updateMember(juniorTranche, uint(-1));\n', '        MemberlistLike(seniorMemberlist).updateMember(seniorTranche, uint(-1));\n', '\n', '        // operator\n', '        DependLike(seniorOperator).depend("tranche", seniorTranche);\n', '        DependLike(juniorOperator).depend("tranche", juniorTranche);\n', '        DependLike(seniorOperator).depend("token", seniorToken);\n', '        DependLike(juniorOperator).depend("token", juniorToken);\n', '\n', '\n', '        // coordinator\n', '        DependLike(coordinator).depend("reserve", reserve);\n', '        DependLike(coordinator).depend("seniorTranche", seniorTranche);\n', '        DependLike(coordinator).depend("juniorTranche", juniorTranche);\n', '        DependLike(coordinator).depend("assessor", assessor);\n', '\n', '        // assessor\n', '        DependLike(assessor).depend("seniorTranche", seniorTranche);\n', '        DependLike(assessor).depend("juniorTranche", juniorTranche);\n', '        DependLike(assessor).depend("reserve", reserve);\n', '\n', '        AuthLike(assessor).rely(coordinator);\n', '        AuthLike(assessor).rely(reserve);\n', '        AuthLike(assessor).rely(assessorAdmin);\n', '\n', '        // assessorAdmin\n', '        DependLike(assessorAdmin).depend("assessor", assessor);\n', '\n', '        \n', '\n', '        FileLike(assessor).file("seniorInterestRate", seniorInterestRate.value);\n', '        FileLike(assessor).file("maxReserve", maxReserve);\n', '        FileLike(assessor).file("maxSeniorRatio", maxSeniorRatio.value);\n', '        FileLike(assessor).file("minSeniorRatio", minSeniorRatio.value);\n', '    }\n', '}']