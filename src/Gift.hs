module Gift where

import qualified PlutusTx
import           PlutusTx.Prelude hiding (Semigroup (..))
import qualified Plutus.Script.Utils.V1.Scripts as PSU.V1
import qualified PlutusLedgerApi.V1       as Ledger.V1
import           PlutusLedgerApi.V1 (Validator (..), ValidatorHash (..), Address (..))
import qualified PlutusLedgerApi.V1.Address   as Ledger.V1

--------------------------
-- On Chain Code
--------------------------
{-# INLINABLE mkValidator #-}
mkValidator :: BuiltinData -> BuiltinData -> BuiltinData -> ()
--mkValidator _ _ _ = ()
mkValidator _ _ _ = trace "Hello world" ()

--------------------------
-- Helper Functions
--------------------------
validator :: Validator
validator = Ledger.V1.mkValidatorScript $$(PlutusTx.compile [|| mkValidator ||])

validatorHash :: ValidatorHash
validatorHash = PSU.V1.validatorHash validator

scriptAddress :: Address
scriptAddress = Ledger.V1.scriptHashAddress validatorHash