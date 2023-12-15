FROM wordpress:php8.3-fpm-alpine

# Set system-wide locale settings
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Updating alpine
RUN apk update && apk upgrade

# Installing packages
RUN for i in zsh neovim git zsh-vcs fzf starship; do apk add --quiet $i; done

# Installing oh-my-zsh
RUN rm -rf ~/.oh-my-zsh \
    && git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# ZSH Autosuggestions & Highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting yarn)/' ~/.zshrc \
    && echo 'ZSH_AUTOSUGGEST_STRATEGY=(history completion)' >>~/.zshrc \
    && echo 'ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)' >>~/.zshrc

# ZSH Prompt
RUN echo 'eval "$(starship init zsh)"' >>~/.zshrc

# Locale
RUN sed -i 's/# export LANG=en_US.UTF-8/export LANG=en_US.UTF-8/' ~/.zshrc \
    && echo 'export LC_ALL=en_US.UTF-8' >>~/.zshrc

# fzf
RUN echo '[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh' >>~/.zshrc

# PHP Redis
RUN apk add --no-cache pcre-dev $PHPIZE_DEPS \
    && echo 'no' | pecl install redis \
    && docker-php-ext-enable redis.so