package ma.dentinos.config;

import ma.dentinos.repository.api.UserRepository;
import ma.dentinos.repository.jdbcMySql.UserRepositoryJdbc;
import ma.dentinos.service.api.AuthService;
import ma.dentinos.service.impl.AuthServiceImpl;

public class ApplicationContext {
    private static ApplicationContext instance;

    private final UserRepository userRepository;
    private final AuthService authService;

    private ApplicationContext() {
        // Initialisation des Repositories
        this.userRepository = new UserRepositoryJdbc();

        // Initialisation des Services
        this.authService = new AuthServiceImpl(userRepository);
    }

    public static ApplicationContext getInstance() {
        if (instance == null) {
            instance = new ApplicationContext();
        }
        return instance;
    }

    public AuthService getAuthService() {
        return authService;
    }

    public UserRepository getUserRepository() {
        return userRepository;
    }
}