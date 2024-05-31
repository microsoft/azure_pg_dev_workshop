package com.contoso.noshnowapi.repositories;

import com.contoso.noshnowapi.models.User;
import org.springframework.data.jpa.repository.*;

public interface UserRepository extends JpaRepository<User, Long>, UserRepositoryCustom {
}
